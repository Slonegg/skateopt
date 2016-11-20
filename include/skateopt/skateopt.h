#pragma once

#include "config.h"
#include <Eigen/QR>
#include <queue>

template<typename T>
class SkateOptProblem
{
public:
	void setSize() = 0;

	virtual T eval(T* gradient, T* hessian) = 0;

private:

};

struct SkateOptOptions
{
	size_t maxNumIterations;
};

template<typename T>
class SkateOptSolver
{
private:
	typedef Eigen::Matrix<T, Eigen::Dynamic, 1> Vector;
	typedef Eigen::Matrix<T, Eigen::Dynamic, Eigen::Dynamic> Matrix;

	struct Candidate
	{
		T J_; ///< cost
		Vector gamma_; ///< candidate solution
	};

public:
	SkateOptSolver(const typename SkateOptProblem<T>::Ptr& problem = SkateOptProblem<T>::Ptr(), const SkateOptOptions& options = SkateOptOptions())
		: problem_(problem)
		, options_(options)
	{
	}

	void solve()
	{
		std::random_device rd;
		std::mt19937 gen(rd());
		std::uniform_real_distribution<T> rnd(0, 1);

		for (unsigned i = 0; i < options_.maxNumIterations; ++i)
		{
			// select candidate solution at random
			int j = rand() % candidates_.size();
			const Candidate& candidate = candidates_[j];

			// select random point in cost function domain
			int k = rand() % problem_->getNumPoints();
			// find neighbours of x
			findNeighbors(X_.row(k), x_neighbors_);
			// optimize cost function in neghborhood of that point
			optimizeLocal(gamma_opt_, x_neighbors_);

			// compute hessian at the optimum point
			problem_->partialEval(gamma_opt_, x_neighbors_, hessian_);
			// QR decomposition of Hessian
			qr_.solve(hessian_);
			// sample direction at random in null space of Hessian
			for (int i = 0; i < hessian_.rows(); ++i)
			{
				if (hessian_[i] > options_.zeroThreshold)
				{
					direction_[i] = rnd();
				}
			}
			direction_ = qr_.

			// optimize function in the new guess
			optimizeLocal(gamma_opt_ + direction_ * options_.step, x_neighbors_);
		}
	}

private:
	SkateOptOptions options_;
	SkateOptProblem<T>::Ptr problem_;
	std::priority_queue<T, Candidate> candidates_;

	std::vector<size_t> x_neighbors_;
	Vector gamma_opt_;
	Matrix hessian_;
	Eigen::ColPivHouseholderQR<Matrix> qr_;
	Vector direction_;
};

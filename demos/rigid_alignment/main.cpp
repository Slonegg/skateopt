#include <boost/program_options/options_description.hpp>
#include <boost/program_options/parsers.hpp>
#include <boost/program_options/variables_map.hpp>
#include <iostream>

namespace po = boost::program_options;

int main(int argc, char **argv)
{
	po::options_description opts("Aligns 3d models and computes error metrics");
	opts.add_options()
		("reference", po::value<std::string>()->required(), "reference model, outliers with be computed with respect to this mode")
		("target", po::value<std::string>()->required(), "target model");

	po::positional_options_description popts;
	popts.add("reference", 1);
	popts.add("target", 1);

	po::variables_map vm;
	try
	{
		po::store(po::command_line_parser(argc, argv).options(opts).positional(popts).run(), vm);
		po::notify(vm);
	}
	catch (boost::program_options::error& e)
	{
		std::cerr << "error: " << e.what() << std::endl << std::endl;
		return 1;
	}

	return 0;
}

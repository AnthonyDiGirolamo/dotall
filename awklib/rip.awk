#!/usr/bin/gawk -E
@include "awklib/cli"
@include "awklib/getopt"
@include "awklib/path"

@namespace "ripawk"

BEGIN {
    awk::Opterr = 1
    awk::Optind = 1

    cli::LOG_DEBUG = 0

    _myshortopts = "vg:h"
    _mylongopts = "verbose,file-pattern:help"

    file_pattern = ".*"
    pattern = ""
    search_path = "."

    while ((_option = awk::getopt(ARGC, ARGV, _myshortopts, _mylongopts)) != -1) {
        switch (_option) {
        case "v":
        case "verbose":
            cli::LOG_DEBUG = 1
            break
        case "g":
        case "file-pattern":
            file_pattern = awk::Optarg
            break
        case "?":
        case "h":
        case "help":
        # default:
            usage()
            break
        }
        cli::print_debug(sprintf("Handle option: %s, Optarg = '%s'", _option, awk::Optarg))
    }
    # Erase handled args
    for (i = 1; i < awk::Optind; i++)
        ARGV[i] = ""

    pattern = ARGV[awk::Optind]
    if (awk::Optind + 1 in ARGV)
        search_path = ARGV[awk::Optind + 1]

    cli::print_debug("file_pattern = " file_pattern)
    cli::print_debug("     pattern = " pattern)
    cli::print_debug(" search_path = " search_path)

    if (pattern == "") {
        print cli::error("Error: ") "Missing pattern"
        usage()
    }

    # cli::print_debug("Non-option arguments:")
    # for (; awk::Optind < ARGC; awk::Optind++) {
    #     cli::print_debug(sprintf("\tARGV[%d] = <%s>",
    #                              awk::Optind,
    #                              ARGV[awk::Optind]))
    # }

    exit 0
}

function usage() {
    print "usage: rip.awk [-v] [-g] PATTERN PATH"
    print "options:"
    print "  -v, --verbose       show debug output"
    print "  -g, --file-pattern  Optional: regex pattern for files to search"
    exit 1
}

java_library(
    name = "time",
    srcs = glob(["**/*.java"]),
    deps = [
        "//third_party/org/joda:joda_convert",
    ],
)

java_binary(
    name = "ZoneInfoCompiler",
    main_class = "org.joda.time.tz.ZoneInfoCompiler",
    runtime_deps = [":time"],
)

genrule(
    name = "compile-tzdb",
    # TODO: do I actually have to list all of the inputs explicitly, even though
    # the tool doesn't need it?
    srcs = ["tz/src"],
    # TODO: do I actually have to list all of the outputs explicitly?
    outs = ["tz/data"],
    cmd = "$(location :ZoneInfoCompiler) -src $(location tz/src) -dst $@ " +
          # Phew, this is ugly...
          "africa " +
          "antarctica " +
          "asia " +
          "australasia " +
          "europe " +
          "northamerica " +
          "southamerica " +
          "pacificnew " +
          "etcetera " +
          "backward " +
          "systemv",
    output_to_bindir = 1,
    tools = [":ZoneInfoCompiler"],
)

# TODO: can I actually package an artifact for publishing similar to this?
java_library(
    name = "joda_time_final",
    visibility = ["//visibility:public"],
    exports = [
        ":compile-tzdb",
        ":time",
    ],
)

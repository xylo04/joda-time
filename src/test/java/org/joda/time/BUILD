java_library(
    name = "time",
    testonly = 1,
    srcs = glob(["**/*.java"]),
    javacopts = ["-XepDisableAllChecks"],
    deps = [
        "//src/main/java/org/joda/time:joda_time_final",
        "//third_party/junit",
        "//third_party/org/joda:joda_convert",
    ],
)

java_test(
    name = "TestAllPackages",
    classpath_resources = ["//src/test/resources"],
    test_class = "org.joda.time.TestAllPackages",
    runtime_deps = [":time"],
)

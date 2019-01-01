# Do not edit. bazel-deps autogenerates this file from dependencies.yaml.
def _jar_artifact_impl(ctx):
    jar_name = "%s.jar" % ctx.name
    ctx.download(
        output = ctx.path("jar/%s" % jar_name),
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        executable = False,
    )
    src_name = "%s-sources.jar" % ctx.name
    srcjar_attr = ""
    has_sources = len(ctx.attr.src_urls) != 0
    if has_sources:
        ctx.download(
            output = ctx.path("jar/%s" % src_name),
            url = ctx.attr.src_urls,
            sha256 = ctx.attr.src_sha256,
            executable = False,
        )
        srcjar_attr = '\n    srcjar = ":%s",' % src_name

    build_file_contents = """
package(default_visibility = ['//visibility:public'])
java_import(
    name = 'jar',
    tags = ['maven_coordinates={artifact}'],
    jars = ['{jar_name}'],{srcjar_attr}
)
filegroup(
    name = 'file',
    srcs = [
        '{jar_name}',
        '{src_name}'
    ],
    visibility = ['//visibility:public']
)\n""".format(artifact = ctx.attr.artifact, jar_name = jar_name, src_name = src_name, srcjar_attr = srcjar_attr)
    ctx.file(ctx.path("jar/BUILD"), build_file_contents, False)
    return None

jar_artifact = repository_rule(
    attrs = {
        "artifact": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "urls": attr.string_list(mandatory = True),
        "src_sha256": attr.string(mandatory = False, default = ""),
        "src_urls": attr.string_list(mandatory = False, default = []),
    },
    implementation = _jar_artifact_impl,
)

def jar_artifact_callback(hash):
    src_urls = []
    src_sha256 = ""
    source = hash.get("source", None)
    if source != None:
        src_urls = [source["url"]]
        src_sha256 = source["sha256"]
    jar_artifact(
        artifact = hash["artifact"],
        name = hash["name"],
        urls = [hash["url"]],
        sha256 = hash["sha256"],
        src_urls = src_urls,
        src_sha256 = src_sha256,
    )
    native.bind(name = hash["bind"], actual = hash["actual"])

def list_dependencies():
    return [
        {"artifact": "junit:junit:3.8.2", "lang": "java", "sha1": "07e4cde26b53a9a0e3fe5b00d1dbbc7cc1d46060", "sha256": "ecdcc08183708ea3f7b0ddc96f19678a0db8af1fb397791d484aed63200558b0", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/junit/junit/3.8.2/junit-3.8.2.jar", "source": {"sha1": "aaa058540bf14ad600dd784de979c46c721ccbbe", "sha256": "79048799144171122d10f8f57bbaf542389e5452a7210c2636000548e984078a", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/junit/junit/3.8.2/junit-3.8.2-sources.jar"}, "name": "junit_junit", "actual": "@junit_junit//jar", "bind": "jar/junit/junit"},
        {"artifact": "org.joda:joda-convert:1.2", "lang": "java", "sha1": "35ec554f0cd00c956cc69051514d9488b1374dec", "sha256": "5703e1a2ac1969fe90f87076c1f1136822bf31d8948252159c86e6d0535c81a8", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/joda/joda-convert/1.2/joda-convert-1.2.jar", "source": {"sha1": "f3daaa17839418e4f066d492079d1365f61b5250", "sha256": "d51f322eb0a819480bb75d5f41263c5158e05a0ac78aa3a132edadd6763192ca", "repository": "http://central.maven.org/maven2/", "url": "http://central.maven.org/maven2/org/joda/joda-convert/1.2/joda-convert-1.2-sources.jar"}, "name": "org_joda_joda_convert", "actual": "@org_joda_joda_convert//jar", "bind": "jar/org/joda/joda_convert"},
    ]

def maven_dependencies(callback = jar_artifact_callback):
    for hash in list_dependencies():
        callback(hash)

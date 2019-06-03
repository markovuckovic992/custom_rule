cmd = '''
  /usr/bin/g++ -o main main.cpp \
    --coverage \
    && cp main* bazel-out/k8-fastbuild/bin \
    '''


def _custom_cc_binary_impl(ctx):
    f = ctx.actions.declare_file("main.gcno")
    f2 = ctx.actions.declare_file("main")

    compile_cmd = ctx.actions.declare_file("compile_cmd")
    ctx.actions.write(compile_cmd, cmd, is_executable=False)

    ctx.actions.run(
        outputs=[f, f2],
        inputs=ctx.files.target,
        executable=compile_cmd,
        use_default_shell_env=True,
    )

    return DefaultInfo(
        files=depset([f] +  ctx.files.target),
        executable=f2,
    )


custom_cc_binary = rule(
    implementation = _custom_cc_binary_impl,
    attrs = {
        "target": attr.label(executable=False, allow_single_file=True, mandatory=True),
    },
)


test_cmd = '''
    JAVA_RUNFILES=bazel-out/k8-fastbuild/bin/simple_test.runfiles \
    LD_LIBRARY_PATH=/home/marko/catkin_ws/devel/lib:/opt/ros/kinetic/lib \
    PATH=/opt/ros/kinetic/bin:/home/marko/bin:/home/marko/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/home/marko/bin:/usr/lib/jvm/jdk1.8.0_161/bin:/home/marko/bin \
    PYTHON_RUNFILES=bazel-out/k8-fastbuild/bin/simple_test.runfiles \
    RUNFILES_DIR=bazel-out/k8-fastbuild/bin/simple_test.runfiles \
    RUN_UNDER_RUNFILES=1 \
    TEST_BINARY=./simple_test \
    TEST_INFRASTRUCTURE_FAILURE_FILE=bazel-out/k8-fastbuild/testlogs/simple_test/test.infrastructure_failure \
    TEST_LOGSPLITTER_OUTPUT_FILE=bazel-out/k8-fastbuild/testlogs/simple_test/test.raw_splitlogs/test.splitlogs \
    TEST_PREMATURE_EXIT_FILE=bazel-out/k8-fastbuild/testlogs/simple_test/test.exited_prematurely \
    TEST_SIZE=medium \
    TEST_SRCDIR=bazel-out/k8-fastbuild/bin/simple_test.runfiles \
    TEST_TARGET=//:test_ \
    TEST_TIMEOUT=300 \
    TEST_TMPDIR=_tmp/c736e69d44b7956f89340b211a844758 \
    TEST_UNDECLARED_OUTPUTS_ANNOTATIONS=bazel-out/k8-fastbuild/testlogs/simple_test/test.outputs_manifest/ANNOTATIONS \
    TEST_UNDECLARED_OUTPUTS_ANNOTATIONS_DIR=bazel-out/k8-fastbuild/testlogs/simple_test/test.outputs_manifest \
    TEST_UNDECLARED_OUTPUTS_DIR=bazel-out/k8-fastbuild/testlogs/simple_test/test.outputs \
    TEST_UNDECLARED_OUTPUTS_MANIFEST=bazel-out/k8-fastbuild/testlogs/simple_test/test.outputs_manifest/MANIFEST \
    TEST_UNDECLARED_OUTPUTS_ZIP=bazel-out/k8-fastbuild/testlogs/simple_test/test.outputs/outputs.zip \
    TEST_UNUSED_RUNFILES_LOG_FILE=bazel-out/k8-fastbuild/testlogs/simple_test/test.unused_runfiles_log \
    TEST_WARNINGS_OUTPUT_FILE=bazel-out/k8-fastbuild/testlogs/simple_test/test.warnings \
    TEST_WORKSPACE=__main__ \
    TZ=UTC \
    WS=/home/marko/custom_cov_rule \
    XML_OUTPUT_FILE=bazel-out/k8-fastbuild/testlogs/simple_test/test.xml \
    /home/marko/.cache/bazel/_bazel_marko/92c312cc2a5e02b4358fdb748a6bd6f7/execroot/__main__/external/bazel_tools/tools/test/test-setup.sh ./simple_test &&
    cp bazel-out/k8-fastbuild/bin/main.gcno . && \    
    geninfo . -o out.info --no-recursion --no-external && \
    genhtml out.info -o bazel-out/k8-fastbuild/bin/html \
'''




def _custom_py_test_runner_impl(ctx):
    f = ctx.actions.declare_directory("html")

    run_test_cmd = ctx.actions.declare_file("run_test_cmd")
    ctx.actions.write(run_test_cmd, test_cmd, is_executable=False)

    ctx.actions.run(
        outputs=[f],
        inputs=ctx.files.test + ctx.files.binary,
        executable=run_test_cmd,
        use_default_shell_env=True,
    )

    return DefaultInfo(
        files=depset([f]),
    )


custom_py_test_runner = rule(
    implementation = _custom_py_test_runner_impl,
    attrs = {
        "test": attr.label(executable=True, cfg="target", mandatory=True),
        "binary": attr.label(executable=True, cfg="target", mandatory=True),
    },
)


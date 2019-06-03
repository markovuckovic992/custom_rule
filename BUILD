load("//:custom_cov.bzl", "custom_cc_binary", "custom_py_test_runner")

cc_binary(
	name="main",
	srcs=["main.cpp"],
)

custom_cc_binary(
	name="main_coverage",
	target="main.cpp",
)

py_test(
	name="simple_test",
	srcs=["simple_test.py"],
	data=[":main_coverage"],
)

custom_py_test_runner(
	name="test_runner",
	test=":simple_test",
	binary=":main_coverage",
	testonly=True,
)

import os, subprocess
import pytest

def test_cov():
	ws = os.environ['WS']
	data = subprocess.Popen('{}/bazel-bin/main'.format(ws), stdout=subprocess.PIPE).communicate()[0]
	assert data == b"Test"

if __name__ == '__main__':
	pytest.main([__file__])

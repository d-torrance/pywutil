from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize

setup(
    ext_modules = cythonize([Extension("wutil", ["src/*.pyx"],
                                       libraries=["WUtil"])],
                            compiler_directives={"embedsignature": True}),
    test_suite = "tests"
)

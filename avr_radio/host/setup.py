__version__ = '0.1.0.dev0'

from setuptools import setup, find_packages

CLASSIFIERS = [
    'Development Status :: 3 - Alpha',
    'Environment :: Console',
    'Intended Audience :: Developers',
    'Natural Language :: English',
    'Operating System :: POSIX',
    'Programming Language :: Python',
    'Topic :: Software Development :: Embedded Systems',
    'Topic :: System :: Hardware'
]

setup(
    name='vwradio',
    version=__version__,
    description='Experiments with VW radios',
    classifiers=CLASSIFIERS,
    author="Mike Naberezny",
    author_email="mike@naberezny.com",
    maintainer="Mike Naberezny",
    maintainer_email="mike@naberezny.com",
    packages=find_packages(),
    install_requires=['pyserial'],
    extras_require={},
    tests_require=[],
    include_package_data=True,
    zip_safe=False,
    test_suite="vwradio.tests",
    entry_points={
        'console_scripts': [
            'vwdecode = vwradio.decode:main',
            'vwdemo = vwradio.demo:main',
        ],
    },
)

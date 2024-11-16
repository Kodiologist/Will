import setuptools

setuptools.setup(
    name = 'will_task',
    version = '0.0.0',
    install_requires = [
        'hy >= 1',
        'iso3166 >= 2.1.1',
        'thoughtforms @ https://github.com/Kodiologist/thoughtforms/archive/688348b.zip'],
    packages = setuptools.find_packages(),
    package_data = dict(will_task = [
        'consent', 'prolific.hy', 'task.hy']))

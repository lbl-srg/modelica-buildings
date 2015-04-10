This directory contains for each test case
a dictionary with variable names that are
used in the regression tests of OpenModelica.

These files can be generated using

  import buildingspy.development.regressiontest as u
  t=u.Tester()
  t.writeOpenModelicaResultDictionary()

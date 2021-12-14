within Buildings.ThermalZones.ReducedOrder.Validation;
package VDI6007 "Validation according to VDI 6007-1"
  extends Modelica.Icons.ExamplesPackage;

annotation (Documentation(info="<html>
  <p>This package contains validation cases for Reduced Order Models according to
  Guideline VDI 6007 Part 1 (VDI, 2012). The guideline defines twelve test cases
  that consecutively test different aspects of building pyhsics behaviour. All
  tests are based on a simple test room, either in a lightweight version (L) or
  as heavyweight (S). A third version changes one interior wall into a second
  exterior wall for the heavyweight construction.</p>
  <p>Comparative results are supplied with the guideline and have been calculated
  using two different programs for electrical circuit calculations (for day 1,
  10 and 60 in hourly steps). The validation procedure is originally thought to
  verifiy the correct implementation of an analytical calculation algorithm
  defined in the guideline. For that, a range of max 0.1 K or max 1 W deviation
  is allowed. As the implementation cannot reflect all aspects of the algorithm,
  the implemented model exceeds these values in some cases.</p>
<h4>References</h4>
<p>VDI. German Association of Engineers Guideline VDI 6007-1 March 2012.
Calculation of transient thermal response of rooms and buildings - modelling of
rooms.</p>
</html>"));
end VDI6007;

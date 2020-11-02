within Buildings.Experimental.DHC.Loads.BaseClasses.Validation;
model GetPeakLoad
  "Model that validates the getPeakLoad function"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load",
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/BaseClasses/Validation/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"))
    "Peak heat flow rate";
  parameter Modelica.SIunits.HeatFlowRate QHea_flow=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/BaseClasses/Validation/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"))
    "Peak heat flow rate";
  parameter Modelica.SIunits.HeatFlowRate QWatHea_flow=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak water heating load",
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/BaseClasses/Validation/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"))
    "Peak water heating flow rate";
equation
  assert(
    abs(
      QCoo_flow-(-383165.6989)) < 1E-3,
    "Error in reading the peak heating load. Read "+String(
      QCoo_flow));
  assert(
    abs(
      QHea_flow-893931.4335) < 1E-3,
    "Error in reading the peak heating load. Read "+String(
      QHea_flow));
  assert(
    abs(
      QWatHea_flow-19496.90012) < 1E-3,
    "Error in reading the peak water heating load. Read "+String(
      QWatHea_flow));
  annotation (
    experiment(
      Tolerance=1e-6,
      StopTime=1.0),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/BaseClasses/Validation/GetPeakLoad.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model tests reading the peak loads from the load file.
If the wrong values are read, then the simulation stops with an error.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 28, 2016, by Michael Wetter:<br/>
Added call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/585\">#585</a>.
</li>
<li>
November 8, 2016, by Michael Wetter:<br/>
Removed test for equality of real variables.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/572\">#572</a>.
</li>
<li>
December 1, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GetPeakLoad;

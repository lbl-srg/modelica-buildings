within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses;
record CoilHeatTransfer
  "Heat transfer performance record for a DX coil with one or multiple stages"
  extends Modelica.Icons.Record;

  parameter Boolean is_cooCoi = true
    "=true, if cooling coil; =false, if heating coil";

  final parameter Boolean sinStaOpe = nSta == 1
    "The data record is used for single speed operation"
    annotation(HideResult=true);

  parameter Integer nSta(
    final min=1)
    "Number of stages"
    annotation (Evaluate = true, Dialog(enable = not sinStaOpe));

  parameter Real minSpeRat(
    final min=0,
    final max=1)=0.2
    "Minimum speed ratio"
    annotation (Dialog(enable = not sinStaOpe));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage
    sta[nSta](
    is_cooCoi=fill(is_cooCoi,nSta))
    constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage
    "Data record for coil performance at each stage";

  parameter Modelica.Units.SI.MassFlowRate m_flow_small=0.0001*sta[nSta].nomVal.m_flow_nominal
    "Small mass flow rate for regularization near zero flow"
    annotation (Dialog(group="Minimum conditions"));

annotation (preferredView="info",
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This record is used as a baseclass for the performance data records
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil</a> and
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.HeatingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.HeatingCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2023, by Karthik Devaprasad:<br/>
Copied contents of previously existing record class DXCoil, and created this baseclass
for use in both heating and cooling coil data records.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
September 25, 2012 by Michael Wetter:<br/>
Added documentation.
</li>
<li>
July 23, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoilHeatTransfer;

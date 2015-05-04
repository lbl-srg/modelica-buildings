within Buildings.Fluid.Chillers.Data;
package BaseClasses "Base classes for package Data"
  extends Modelica.Fluid.Icons.BaseClassLibrary;

  record Chiller "Base classes for chiller models"
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
      "Reference capacity (negative number)"
      annotation (Dialog(group="Nominal condition"));
    parameter Real COP_nominal "Reference coefficient of performance"
      annotation (Dialog(group="Nominal condition"));

    parameter Real PLRMax(min=0) "Maximum part load ratio";
    parameter Real PLRMinUnl(min=0) "Minimum part unload ratio";
    parameter Real PLRMin(min=0) "Minimum part load ratio";

    parameter Real etaMotor(min=0, max=1)
      "Fraction of compressor motor heat entering refrigerant";

    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
      "Nominal mass flow at evaporator"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
      "Nominal mass flow at condenser"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.Temperature TEvaLvg_nominal
      "Temperature of fluid leaving evaporator at nominal condition"
      annotation (Dialog(group="Nominal condition"));

    constant Integer nCapFunT "Number of coefficients for capFunT"
      annotation (Dialog(group="Performance curves"));
    constant Integer nEIRFunT "Number of coefficients for capFunT"
      annotation (Dialog(group="Performance curves"));
    constant Integer nEIRFunPLR "Number of coefficients for capFunT"
      annotation (Dialog(group="Performance curves"));
    parameter Real capFunT[nCapFunT] "Biquadratic coefficients for capFunT"
      annotation (Dialog(group="Performance curves"));
    parameter Real EIRFunT[nEIRFunT] "Biquadratic coefficients for EIRFunT"
      annotation (Dialog(group="Performance curves"));
    parameter Real EIRFunPLR[nEIRFunPLR] "Coefficients for EIRFunPLR"
      annotation (Dialog(group="Performance curves"));
    parameter Modelica.SIunits.Temperature TEvaLvgMin
      "Minimum value for leaving evaporator temperature"
      annotation (Dialog(group="Performance curves"));
    parameter Modelica.SIunits.Temperature TEvaLvgMax
      "Maximum value for leaving evaporator temperature"
      annotation (Dialog(group="Performance curves"));

    annotation (preferredView="info",
    Documentation(info="<html>
This is the base record for chiller models.
</html>",
  revisions="<html>
<ul>
<li>
September 15, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
      Icon(graphics={
          Text(
            extent={{-95,53},{-12,-2}},
            lineColor={0,0,255},
            textString="COP"),
          Text(
            extent={{7,55},{90,0}},
            lineColor={0,0,255},
            textString="%COP_nominal"),
          Text(
            extent={{-105,-9},{-48,-48}},
            lineColor={0,0,255},
            textString="Q"),
          Text(
            extent={{2,-16},{94,-38}},
            lineColor={0,0,255},
            textString="%QEva_flow_nominal"),
          Text(
            extent={{-95,-49},{-12,-104}},
            lineColor={0,0,255},
            textString="PLR_minUnl"),
          Text(
            extent={{7,-53},{84,-94}},
            lineColor={0,0,255},
            textString="%PLRMinUnl")}));
  end Chiller;

  annotation(preferredView="info",
  Documentation(info="<html>
This package contains the common parameters that are used
to specify the performance data
for the chiller models
<a href=\"Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Chillers.ElectricEIR</a>
and
<a href=\"Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>.
</html>", revisions="<html>
<ul>
<li>
September 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BaseClasses;

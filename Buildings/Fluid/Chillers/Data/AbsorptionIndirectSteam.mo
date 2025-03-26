within Buildings.Fluid.Chillers.Data;
package AbsorptionIndirectSteam
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Generic data record for absorption indirect chiller"
    extends Modelica.Icons.Record;

    parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal(final max=0)
      "Nominal evaporator cooling capacity (negative number)"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.Power P_nominal "Nominal absorber pump power"
      annotation (Dialog(group="Nominal condition"));

    parameter Real PLRMax(min=0)
    "Maximum part load ratio"
     annotation (Dialog(group="Nominal condition"));
    parameter Real PLRMin(min=0)
    "Minimum part load ratio"
      annotation (Dialog(group="Nominal condition"));

    parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
      "Nominal mass flow rate at condenser"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
      "Nominal mass flow rate at evaporator"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit=
          "Pa") = 30000
      "Pressure difference at condenser at nominal mass flow rate"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit=
          "Pa") = 30000
      "Pressure difference at evaporator at nominal mass flow rate"
      annotation (Dialog(group="Nominal condition"));

    parameter Real capFunEva[4]
    "Cubic coefficients for the evaporator capacity factor as a function of temperature curve"
      annotation (Dialog(group="Performance curves"));
    parameter Real capFunCon[4]
    "Cubic coefficients for capFunCon for the condenser capacity factor as a function of temperature curve"
      annotation (Dialog(group="Performance curves"));
    parameter Real genHIR[4]
    "Cubic coefficients for the generator heat input to chiller operating capacity"
      annotation (Dialog(group="Performance curves"));
    parameter Real genConT[4]
    "Cubic coefficients for heat input modifier based on the generator input temperature"
      annotation (Dialog(group="Performance curves"));
    parameter Real genEvaT[4]
    "Cubic coefficients for heat input modifier based on the evaporator input temperature"
      annotation (Dialog(group="Performance curves"));
    parameter Real EIRP[3]
    "Quadratic coefficients for the actual absorber pumping power to the nominal pumping power"
      annotation (Dialog(group="Performance curves"));

    annotation (
      defaultComponentName="datChi",
      defaultComponentPrefixes="parameter",
      Documentation(info=
                   "<html>
<p>
This record is used as a template for performance data
for the absorption chiller model
<a href=\"modelica://Buildings.Fluid.Chillers.AbsorptionIndirectSteam\">
Buildings.Fluid.Chillers.AbsorptionIndirectSteam</a>.
</p>
</html>",
  revisions="<html>
<ul>
<li>
July 3, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

 annotation(preferredView="info",
 Documentation(info="<html>
<p>
Package with performance data for absorption indirect chiller.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectSteam;

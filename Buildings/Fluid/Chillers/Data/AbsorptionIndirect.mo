within Buildings.Fluid.Chillers.Data;
package AbsorptionIndirect
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Generic data record for absorption indirect chiller"
    extends Modelica.Icons.Record;

    parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(final max=0)
     "Nominal evaporator cooling capacity (negative number)"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.Power P_nominal "Nominal absorber pump power"
      annotation (Dialog(group="Nominal condition"));
    parameter Real PLRMax(min=0)
    "Maximum part load ratio"
     annotation (Dialog(group="Nominal condition"));
    parameter Real PLRMin(min=0)
    "Minimum part load ratio"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
      "Nominal mass flow at evaporator"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
      "Nominal mass flow at condenser"
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
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirect\">
Buildings.Fluid.Chillers.AbsorptionIndirect</a>.
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

  record AbsorptionIndirectChiller_EnergyPlus =
    Buildings.Fluid.Chillers.Data.AbsorptionIndirect.Generic (
     QEva_flow_nominal=-10000,
     P_nominal=150,
     PLRMax=1,
     PLRMin=0.15,
     mEva_flow_nominal=0.247,
     mCon_flow_nominal=1.1,
     capFunEva={0.690571,0.065571,-0.00289,0},
     capFunCon={0.245507,0.023614,0.0000278,0.000013},
     genHIR={0.18892,0.968044,1.119202,-0.5034},
     EIRP={1,0,0},
     genConT={0.712019,-0.00478,0.000864,-0.000013},
     genEvaT={0.995571,0.046821,-0.01099,0.000608})
    "EnergyPlus absorption chiller performance data"
  annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info="<html>
<p>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Chiller:absorption indirect,
   10000,                    !- Reference Cooling Capacity {W}
    150,                     !- Reference Power {W}
    0.247,                   !- Reference Chilled Water Flow Rate {m3/s}
    1.1,                     !- Reference Condenser Water Flow Rate {m3/s}
    0.15,                    !- Minimum Part Load Ratio
    1.0,                     !- Maximum Part Load Ratio
    0.10,                    !- Minimum Unloading Ratio
</pre>
</html>", revisions="<html>
<ul>
<li>
July 3, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
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
end AbsorptionIndirect;

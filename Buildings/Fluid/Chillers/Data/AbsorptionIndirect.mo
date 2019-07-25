within Buildings.Fluid.Chillers.Data;
package AbsorptionIndirect
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Generic data record for absorption indirect chiller"
    extends Modelica.Icons.Record;

    parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)
     "Nominal evaporator cooling capacity_negative number"
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
    parameter Real  capFunEva[ncapFunEva]
    "Cubic coefficients for the evaporator capacity factor as a function of temperature curve"
      annotation (Dialog(group="Performance curves"));
    parameter Real  capFunCon[ncapFunCon]
    "Cubic coefficients for capFunCon for the condenser capacity factor as a function of temperature curve"
      annotation (Dialog(group="Performance curves"));
    parameter Real GenHIR[nGenHIR]
    "Cubic coefficients for the generator heat input to chiller operating capacity"
      annotation (Dialog(group="Performance curves"));
    parameter Real GenConT[nGenConT]
    "Cubic coefficients for heat input modifier based on the generator input temperature"
      annotation (Dialog(group="Performance curves"));
    parameter Real GenEvaT[nGenEvaT]
    "Cubic coefficients for heat input modifier based on the evaporator input temperature"
      annotation (Dialog(group="Performance curves"));
    parameter Real EIRP[nEIRP]
    "Quadratic coefficients for the actual absorber pumping power to the nominal pumping power."
      annotation (Dialog(group="Performance curves"));
  protected
    constant Integer ncapFunEva=4
    "Number of coefficients for capFunEva"
      annotation (Dialog(group="Performance curves"));
    constant Integer ncapFunCon=4
    "Number of coefficients for capFunCon"
      annotation (Dialog(group="Performance curves"));
    constant Integer nEIRP=3
    "Number of coefficients for EIRP"
      annotation (Dialog(group="Performance curves"));
    constant Integer nGenHIR=4
    "Number of coefficients for GenHIR"
      annotation (Dialog(group="Performance curves"));
     constant Integer nGenConT=4
    "Number of coefficients for GenConT"
      annotation (Dialog(group="Performance curves"));
      constant Integer nGenEvaT=4
    "Number of coefficients for GenEvaT"
      annotation (Dialog(group="Performance curves"));

    annotation (
      defaultComponentName="datChi",
      defaultComponentPrefixes="parameter",
      Documentation(info=
                   "<html>
This record is used as a template for performance data
for the chiller model
<a href=\"Buildings.Fluid.Chillers.Absorption_Indirect_Steam\">
Buildings.Fluid.Chillers.Absorption_Indirect_Steam</a>.
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

  record EnergyPlusAbsorptionChiller =
    Buildings.Fluid.Chillers.Data.AbsorptionIndirect.Generic (
     QEva_flow_nominal=-8200,
     P_nominal=150,
     PLRMax=1,
     PLRMin=0.15,
     mEva_flow_nominal=0.247,
     mCon_flow_nominal=1.09,
     capFunEva={0.690571,0.065571,-0.00289,0},
     capFunCon={0.245507,0.023614,0.0000278,0.000013},
     GenHIR={0.18892,0.968044,1.119202,-0.5034},
     EIRP={1,0,0},
     GenConT={0.712019,-0.00478,0.000864,-0.000013},
     GenEvaT={0.995571,0.046821,-0.01099,0.000608});
 annotation(preferredView="info",
 Documentation(info="<html>
<p>
Package with performance data for absorption indirect chiller.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 3, 2019, by Hagar Elarga <br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirect;

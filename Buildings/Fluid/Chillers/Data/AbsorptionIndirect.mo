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

    /*
  parameter Real  capFunGen[ncapFunGen]
  "Cubic coefficients for capFunGen for the generator capacity factor as a function of temperature curve"
  annotation (Dialog(group="Performance curves"));
  */

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

    /*
  constant Integer ncapFunGen=4
  "Number of coefficients for capFunGen"
  annotation (Dialog(group="Performance curves"));
  */

    constant Integer nGenHIR=4
    "Number of coefficients for GenHIR"
      annotation (Dialog(group="Performance curves"));
     constant Integer nGenConT=4
    "Number of coefficients for GenConT"
      annotation (Dialog(group="Performance curves"));
      constant Integer nGenEvaT=4
    "Number of coefficients for GenEvaT"
      annotation (Dialog(group="Performance curves"));


  /*
  parameter Modelica.SIunits.Temperature TEvaLvgMin
    "Minimum value for leaving evaporator temperature"
    annotation (Dialog(group="Performance curves"));
    
  parameter Modelica.SIunits.Temperature TEvaLvgMax
    "Maximum value for leaving evaporator temperature"
    annotation (Dialog(group="Performance curves"));
    
  parameter Modelica.SIunits.Temperature TConLvg_nominal
    "Temperature of fluid leaving condenser at nominal condition";
    
  parameter Modelica.SIunits.Temperature TConLvgMin
    "Minimum value for leaving condenser temperature"
    annotation (Dialog(group="Performance curves"));
    
  Modelica.SIunits.Temperature TConLvgMax
    "Maximum value for leaving condenser temperature"
    annotation (Dialog(group="Performance curves"));
    
    parameter Modelica.SIunits.Temperature TEvaLvg_nominal
    "Temperature of fluid leaving evaporator at nominal condition"
    annotation (Dialog(group="Nominal condition"))
    */

        /*
  final parameter Modelica.SIunits.Temperature TConEnt_nominal=per.TConEnt_nominal
    "Temperature of fluid entering condenser at nominal condition";
  final parameter Modelica.SIunits.Temperature TEvaLvg_nominal=per.TEvaLvg_nominal
    "Temperature of fluid leaving condenser at nominal condition";
  final parameter Modelica.SIunits.Temperature TConEntMin=per.TConEntMin
    "Minimum temperature of fluid entering condenser at nominal condition";
  final parameter Modelica.SIunits.Temperature TConEntMax=per.TConEntMax
    "Maximum temperature of fluid entering condenser at nominal condition";
  final parameter Modelica.SIunits.Temperature TEvaLvgMax= per.TEvaLvgMax
    "Maximum temperature of fluid leaving evaporator  at nominal condition";
  final parameter Modelica.SIunits.Temperature TEvaLvgMin=per.TEvaLvgMin
    "Minimum temperature of fluid leaving evaporator  at nominal condition";
   */



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
     QEva_flow_nominal=-10000,
     P_nominal=150,
     PLRMax=1,
     PLRMin=0.15,
     mEva_flow_nominal=0.2,
     mCon_flow_nominal=1.1,
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

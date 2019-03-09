within Buildings.Fluid.HeatPumps.Data;
package BaseClasses "Base classes for package Data"
  extends Modelica.Icons.BasesPackage;

  record HeatPump "Base Classes for HeatPump models"
   extends Modelica.Icons.Record;

   parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal "Reference capacity";

   parameter Modelica.SIunits.Efficiency   COP_nominal
      "Reference coefficient of performance";


  final parameter Real PLRMax=1.15                "Maximum part load ratio";
  final parameter Real PLRMinUnl=0.1              "Minimum part unload ratio";
  final parameter Real PLRMin=0.1                 "Minimum part load ratio";

  parameter Real etaMotor(min=0, max=1)     "Fraction of compressor motor heat entering refrigerant";



  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
      "Nominal mass flow at Condenser"
       annotation (Dialog(group="Nominal condition"));
   parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal
      "Nominal mass flow at Evaorator"
       annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TConLvg_nominal
      "Nominal leaving Condenser temperature"
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TConEnt_nominal
      "Temperature of fluid entering Condenser at nominal condition"
       annotation (Dialog(group="Nominal condition"));

   parameter Modelica.SIunits.Temperature TConEntMin
      "Minimum value for entering Condenser temperature"
      annotation (Dialog(group="Performance curves"));
   parameter Modelica.SIunits.Temperature TConEntMax
      "Maximum value for entering Condenser temperature"
      annotation (Dialog(group="Performance curves"));
   parameter Modelica.SIunits.Temperature TEvaLvgMin
      "Minimum value for leaving Evaorator temperature"
      annotation (Dialog(group="Performance curves"));
    parameter Modelica.SIunits.Temperature TEvaLvgMax
      "Maximum value for leaving Evaorator temperature"
      annotation (Dialog(group="Performance curves"));



   constant Integer nCapFunT "Number of coefficients for capFunT"
     annotation (Dialog(group="Performance curves"));
   constant Integer nEIRFunT "Number of coefficients for EIRFunT"
     annotation (Dialog(group="Performance curves"));
   constant Integer nEIRFunPLR "Number of coefficients for EIRFunPLR"
     annotation (Dialog(group="Performance curves"));
   parameter Real capFunT[nCapFunT] "Biquadratic coefficients for capFunT"
     annotation (Dialog(group="Performance curves"));
   parameter Real EIRFunT[nEIRFunT] "Biquadratic coefficients for EIRFunT"
     annotation (Dialog(group="Performance curves"));
   parameter Real EIRFunPLR[nEIRFunPLR] "Coefficients for EIRFunPLR"
     annotation (Dialog(group="Performance curves"));



   annotation (
     defaultComponentName="datHeaPum",
     preferredView="info",
   Documentation(info="<html>
<p>
This is the base record for heat pump models.
</p>
</html>",   revisions=
           "<html>
<ul>
<li>
December 6, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
     Icon(graphics={
         Text(
           extent={{-95,53},{-12,-2}},
           lineColor={0,0,255},
          textString="QCon_nominal"),
         Text(
           extent={{-95,-9},{-8,-46}},
           lineColor={0,0,255},
          textString="COP_nominal"),
         Text(
           extent={{-97,-45},{-4,-102}},
           lineColor={0,0,255},
          textString="TConLvg_nominal")}));
  end HeatPump;

  annotation(preferredView="info",
  Documentation(info="<html>
This package contains the common parameters that are used
to specify the heat pump models in
<a href=\"Buildings.Fluid.HeatPumps\">
Buildings.Fluid.HeatPumps</a>.
</html>", revisions="<html>
<ul>
<li>
December 6, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end BaseClasses;

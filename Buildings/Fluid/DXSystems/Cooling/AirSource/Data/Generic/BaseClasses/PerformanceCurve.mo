within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses;
record PerformanceCurve "Data record for a performance curve"
  extends Modelica.Icons.Record;
//-----------------------------Performance curves-----------------------------//
  parameter Real  capFunT[6]
    "Biquadratic coefficients for cooling capacity function of temperature"
    annotation (Dialog(group="Performance curves"));
  parameter Real  capFunFF[:]
    "Polynomial coefficients for cooling capacity function of flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real  EIRFunT[6]
    "Biquadratic coefficients for EIR function of temperature"
    annotation (Dialog(group="Performance curves"));
  parameter Real  EIRFunFF[:]
    "Polynomial coefficients for EIR function of flow fration"
    annotation (Dialog(group="Performance curves"));
//------------------------Range for performance curves------------------------//
  parameter Modelica.Units.SI.Temperature TConInMin
    "Minimum condenser inlet temperature for cooling capacity function"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Modelica.Units.SI.Temperature TConInMax
    "Maximum condenser inlet temperature for cooling capacity function"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Modelica.Units.SI.Temperature TEvaInMin
    "Minimum evaporator inlet temperature for cooling capacity function"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Modelica.Units.SI.Temperature TEvaInMax
    "Maximum evaporator inlet temperature for cooling capacity function"
    annotation (Dialog(group="Minimum and maximum values"));

  parameter Real  ffMin
    "Minimum flow fraction for which performance data are valid"
    annotation (Dialog(group="Minimum and maximum values"));
  parameter Real  ffMax
    "Maximum flow fraction for which performance data are valid"
    annotation (Dialog(group="Minimum and maximum values"));

  annotation (defaultComponentName="per", Documentation(info="<html>
<p>
  This record declares the data used to specify performance curves for air source DX coils.
</p>
<p>
 See the information section of
 <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil\">
 Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil</a>
 for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 25, 2012 by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
August 15, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-95,53},{-12,-2}},
          textColor={0,0,255},
          textString="capFunT"),
        Text(
          extent={{7,55},{90,0}},
          textColor={0,0,255},
          textString="%capFunT"),
        Text(
          extent={{-105,-9},{-48,-48}},
          textColor={0,0,255},
          textString="capFunFF"),
        Text(
          extent={{2,-16},{94,-38}},
          textColor={0,0,255},
          textString="%capFunFF"),
        Text(
          extent={{-95,-49},{-12,-104}},
          textColor={0,0,255},
          textString="EIRFunT"),
        Text(
          extent={{7,-53},{84,-94}},
          textColor={0,0,255},
          textString="%EIRFunT")}));
end PerformanceCurve;

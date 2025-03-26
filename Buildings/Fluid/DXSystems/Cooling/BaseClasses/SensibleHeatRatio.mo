within Buildings.Fluid.DXSystems.Cooling.BaseClasses;
block SensibleHeatRatio "Calculates the sensible heat ratio"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TEvaIn
    "Temperature of air entering the cooling coil"
     annotation (Placement(transformation(extent={{-120,62},{-100,82}})));
  Modelica.Blocks.Interfaces.RealInput XADP(
    min=0,
    max=1.0) "Humidity mass fraction of air at ADP"
   annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput hADP(
    nominal=40000,
    quantity="SpecificEnergy",
    unit="J/kg") "Specific enthalpy of air at ADP"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealInput hEvaIn
    "Specific enthalpy of air entering the coil"
    annotation (Placement(transformation(extent={{-120,23},{-100,43}})));
  Modelica.Blocks.Interfaces.RealOutput SHR(
    min=0,
    max=1.0)
    "Sensible Heat Ratio: Ratio of sensible heat load to total heat load"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.Units.SI.SpecificEnthalpy h_TEvaIn_XADP
    "Enthalpy at inlet air temperature and humidity mass fraction at ADP";
  Real entRat "Enthalpy ratio";
  parameter Modelica.Units.SI.SpecificEnthalpy epsH=100
    "Small value for enthalpy to avoid division by zero";
equation
//===================================Sensible heat ratio calculation===========================================//
  //Coil on-off condition
  if on then
   //Calculate enthalpy at inlet air temperature and absolute humidity at ADP i.e. h_TEvaIn_wADP
    h_TEvaIn_XADP = Medium.specificEnthalpy_pTX(
      p=p,
      T=TEvaIn,
      X=cat(1, {XADP}, {1-XADP}));
    //Calculate Sensible Heat Ratio
    entRat = (h_TEvaIn_XADP - hADP)/
      Buildings.Utilities.Math.Functions.smoothMax(
        x1 =     epsH,
        x2 =     hEvaIn - hADP,
        deltaX = 0.1*epsH);
    SHR = Buildings.Utilities.Math.Functions.smoothMin(
      x1=entRat,
      x2=0.999,
      deltaX=0.0001)
      "To restrict the value of SHR in case of zero mass flow rate or dry coil condition";
  else  //Coil off
    h_TEvaIn_XADP = 0;
    entRat        = 1;
    SHR           = 0;
  end if;

  annotation (defaultComponentName="shr",
          Documentation(info="<html>
<p>
This block computes the sensible heat ratio.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 26, 2018, by Michael Wetter:<br/>
Replaced <code>algorithm</code> with <code>equation</code>.
</li>
<li>
September 24, 2012 by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
August 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),Icon(graphics={Text(
          extent={{-100,98},{98,-98}},
          textColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Qs/Q")}));
end SensibleHeatRatio;

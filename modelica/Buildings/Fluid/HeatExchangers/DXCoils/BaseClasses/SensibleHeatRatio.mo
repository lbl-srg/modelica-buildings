within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block SensibleHeatRatio "Calculates sensible heat ratio"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TIn
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
  Modelica.Blocks.Interfaces.RealInput hIn
    "Specific enthalpy of air entering the coil"
    annotation (Placement(transformation(extent={{-120,23},{-100,43}})));
  Modelica.Blocks.Interfaces.RealOutput SHR(
    min=0,
    max=1.0)
    "Sensible Heat Ratio: Ratio of sensible heat load to total heat load"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.SIunits.SpecificEnthalpy h_TIn_XADP
    "Enthalpy at inlet air temperature and humidity mass fraction at ADP";
  Modelica.SIunits.SpecificEnthalpy del_hSen
    "Sensible component of total enthalpy change";
  Modelica.SIunits.SpecificEnthalpy del_hTot "Total enthalpy change";
  Real entRat "Enthalpy ratio";
  parameter Modelica.SIunits.SpecificEnthalpy epsH = 100
    "Small value for enthalpy to avoid division by zero";
equation
//===================================Sensible heat ratio calculation===========================================//
  //Coil on-off condition
  if on then
   //Calculate enthalpy at inlet air temperature and absolute humidity at ADP i.e. h_TIn_wADP
    h_TIn_XADP = Medium.h_pTX(
      p=p,
      T=TIn,
      X={XADP, 1-(XADP)});
    del_hSen=h_TIn_XADP - hADP;
    del_hTot=hIn - hADP;
    //Calculate Sensible Heat Ratio
    entRat = del_hSen/
      Buildings.Utilities.Math.Functions.smoothMax(
        epsH,
        del_hTot,
        deltaX=0.01*epsH);
    SHR= Buildings.Utilities.Math.Functions.smoothMin(
      x1=entRat,
      x2=1.0,
      deltaX=0.01)
      "To restrict the value of SHR in case of zero mass flow rate or dry coil condition";
  else  //Coil off
    h_TIn_XADP = 0;
    del_hSen=0;
    del_hTot=0;
    entRat=1;
    SHR=0;
  end if;
  annotation (defaultComponentName="shr",
          Documentation(info="<html>
<p>
Sensible heat ratio is calculated by this block using the air properties at both 
inlet and ADP conditions.</p>
</html>",
revisions="<html>
<ul>
<li>
August 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),Icon(graphics={Text(
          extent={{-100,98},{98,-98}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Qs/Q")}),
    Diagram(graphics));
end SensibleHeatRatio;

within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses;
block CapacityCalculator
  "Calculates heating and cooling capacities for different stages"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.InputInterface;
  parameter Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.HPData
                                                                      datHP
    "Heat pump data";
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealOutput Q1_flow(unit="W")
    "Vol1 heat transfer rate"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power", unit="W")
    "Electrical power consumed by the compressor"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}},
                                                                     rotation=0)));

  HeatingCapacity heaCap(
    heaMod=datHP.heaMod) "Calculates heating capacity"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  CoolingCapacity cooCap(
    cooMod=datHP.cooMod) "Calculates cooling capacity"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  DXCoils.BaseClasses.SpeedShift speQHea_flow(
    final variableSpeedCoil=true,
    final nSta=datHP.heaMod.nSta,
    final speSet=datHP.heaMod.heaPer.spe) "Interpolates QHea_flow"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  DXCoils.BaseClasses.SpeedShift spePHea(
    final variableSpeedCoil=true,
    final speSet=datHP.heaMod.heaPer.spe,
    final nSta=datHP.heaMod.nSta) "Interpolates EIR"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  DXCoils.BaseClasses.SpeedShift speQCoo_flow(
    final variableSpeedCoil=true,
    final nSta=datHP.cooMod.nSta,
    final speSet=datHP.cooMod.cooPer.spe) "Interpolates QHea_flow"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  DXCoils.BaseClasses.SpeedShift spePCoo(
    final variableSpeedCoil=true,
    final speSet=datHP.cooMod.cooPer.spe,
    final nSta=datHP.cooMod.nSta) "Interpolates EIR"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSwitch modSwiQ_flow
    "Switches between heating and cooling inputs"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSwitch modSwiP
    "Switches between heating and cooling inputs"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
equation
  connect(speRat, speQHea_flow.speRat) annotation (Line(
      points={{-120,70},{-26,70},{-26,60},{-12,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, spePHea.speRat) annotation (Line(
      points={{-120,70},{-26,70},{-26,20},{-12,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speQCoo_flow.speRat)  annotation (Line(
      points={{-120,70},{-26,70},{-26,-20},{-12,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, spePCoo.speRat)  annotation (Line(
      points={{-120,70},{-26,70},{-26,-60},{-12,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCap.QHea1_flow, speQHea_flow.u) annotation (Line(
      points={{-39,44},{-30,44},{-30,52},{-12,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCap.PHea, spePHea.u) annotation (Line(
      points={{-39,36},{-30,36},{-30,12},{-12,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.QCoo1_flow, speQCoo_flow.u)  annotation (Line(
      points={{-39,-36},{-30,-36},{-30,-28},{-12,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.PCoo, spePCoo.u)  annotation (Line(
      points={{-39,-44},{-30,-44},{-30,-68},{-12,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1, heaCap.T1) annotation (Line(
      points={{-120,40},{-98,40},{-98,44},{-61,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1, cooCap.T1) annotation (Line(
      points={{-120,40},{-97,40},{-97,-36},{-61,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow, heaCap.m1_flow) annotation (Line(
      points={{-120,10},{-92,10},{-92,41},{-61,41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow, cooCap.m1_flow) annotation (Line(
      points={{-120,10},{-92,10},{-92,-39},{-61,-39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2, heaCap.T2) annotation (Line(
      points={{-120,-20},{-86,-20},{-86,38},{-61,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2, cooCap.T2) annotation (Line(
      points={{-120,-20},{-86,-20},{-86,-42},{-61,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow, heaCap.m2_flow) annotation (Line(
      points={{-120,-50},{-80,-50},{-80,35},{-61,35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow, cooCap.m2_flow) annotation (Line(
      points={{-120,-50},{-80,-50},{-80,-45},{-61,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speQHea_flow.y, modSwiQ_flow.hea) annotation (Line(
      points={{11,60},{20,60},{20,38},{58,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speQCoo_flow.y, modSwiQ_flow.coo) annotation (Line(
      points={{11,-20},{20,-20},{20,22},{58,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, modSwiQ_flow.mod) annotation (Line(
      points={{-120,100},{50,100},{50,30},{58,30}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(spePHea.y, modSwiP.hea) annotation (Line(
      points={{11,20},{30,20},{30,-22},{58,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(spePCoo.y, modSwiP.coo) annotation (Line(
      points={{11,-60},{30,-60},{30,-38},{58,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, modSwiP.mod) annotation (Line(
      points={{-120,100},{50,100},{50,-30},{58,-30}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSwiQ_flow.y, Q1_flow) annotation (Line(
      points={{81,30},{110,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modSwiP.y, P) annotation (Line(
      points={{81,-30},{110,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, heaCap.mode) annotation (Line(
      points={{-120,100},{-76,100},{-76,50},{-61,50}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, cooCap.mode) annotation (Line(
      points={{-120,100},{-76,100},{-76,-30},{-61,-30}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, spePCoo.stage) annotation (Line(
      points={{-120,100},{-20,100},{-20,-52},{-12,-52}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, speQCoo_flow.stage) annotation (Line(
      points={{-120,100},{-20,100},{-20,-12},{-12,-12}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, spePHea.stage) annotation (Line(
      points={{-120,100},{-20,100},{-20,28},{-12,28}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, speQHea_flow.stage) annotation (Line(
      points={{-120,100},{-20,100},{-20,68},{-12,68}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(rho, heaCap.rho) annotation (Line(
      points={{-120,-80},{-72,-80},{-72,32},{-61,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rho, cooCap.rho) annotation (Line(
      points={{-120,-80},{-72,-80},{-72,-48},{-61,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="capCal", Diagram(graphics), Documentation(info="<html>
<p>
This block calculates the rate of heat transfer for heating or cooling the water on load side.
The stage input decides heating or cooling operation. Odd value indicates heating mode while even stage number indicates cooling operation. 
The model is based on four non-dimensional eqautions to calculate the heat pump performance. 
These equations are added in 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity</a> and 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity
</p>
<p>
This block calculates heating and cooling rate at each specified stage in heat pump data record. Then depending on the 
stage input the heat rates are interpolated between states. 
The depending on the stage value load side heat transfer (heating or cooling) rate and compressor power is given at output.    
</p>
</html>",
revisions="<html>
<ul>
<li>
April 19, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),Icon(graphics),            Diagram(graphics));
end CapacityCalculator;

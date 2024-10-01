within Buildings.Fluid.Storage.Ice_ntu_ini.BaseClasses;
model soc_calc
  Modelica.Units.SI.Temperature Ttank;
  Real SOC(start=0);
  Modelica.Units.SI.Temperature Tliq(start=273.15+20);
  Modelica.Units.SI.Temperature Tsol(start=273.15);
  Modelica.Units.SI.SpecificHeatCapacity Cp_ice = 2030;
  Modelica.Units.SI.SpecificHeatCapacity Cp_liq = 4180;
  parameter Modelica.Units.SI.Volume Vtank;
  Modelica.Units.SI.Density rho = 998.2041322005837;
  parameter Modelica.Units.SI.SpecificEnergy Hf;
  Modelica.StateGraph.TransitionWithSignal transitionWithSignal
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.StateGraph.InitialStepWithSignal liq(nOut=1, nIn=1)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.StateGraph.StepWithSignal trans(nIn=2, nOut=2)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.StateGraph.TransitionWithSignal transitionWithSignal1
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.StateGraph.TransitionWithSignal transitionWithSignal2
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.StateGraph.StepWithSignal sol(nIn=1, nOut=1)
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.StateGraph.TransitionWithSignal transitionWithSignal3
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Interfaces.RealInput Q
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Sources.BooleanExpression
                                         booleanExpression(y=lat_liq)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Interfaces.RealOutput T_tank
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput SOC_out
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Sources.BooleanExpression
                                         booleanExpression1(y=sol_lat)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.BooleanExpression
                                         booleanExpression2(y=lat_sol)
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

protected
  Boolean lat_liq;
  Boolean sol_lat;
  Boolean lat_sol;
  Boolean liq_lat;

public
  Modelica.Blocks.Sources.BooleanExpression
                                         booleanExpression3(y=liq_lat)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  SOC_out = SOC;
  Ttank = T_tank;
  sol_lat =(Q > 0) and (Ttank >= 273.15);
  lat_liq =(Q > 0) and (SOC <= 0);
  lat_sol =(Q < 0) and (SOC >= 1);
  liq_lat =(Q < 0) and (Ttank <= 273.15);
  der(Tliq) * Vtank * rho * Cp_liq =if liq.active then Q else 0;
  der(Tsol) * Vtank * rho * Cp_ice =if sol.active then Q else 0;
  der(SOC) =if trans.active then -Q/(Hf * Vtank * rho)  else 0;
  if liq.active then
    Ttank = Tliq;
  elseif trans.active then
    Ttank = 273.15;
  else
    Ttank = Tsol;
  end if;

  connect(transitionWithSignal.outPort, trans.inPort[1]) annotation (Line(
        points={{-28.5,50},{-14,50},{-14,49.75},{-1,49.75}}, color={0,0,0}));
  connect(trans.outPort[1], transitionWithSignal1.inPort) annotation (Line(
        points={{20.5,49.875},{34,49.875},{34,50},{46,50}}, color={0,0,0}));
  connect(trans.outPort[2], transitionWithSignal2.inPort) annotation (Line(
        points={{20.5,50.125},{36,50.125},{36,10},{46,10}}, color={0,0,0}));
  connect(liq.outPort[1], transitionWithSignal.inPort)
    annotation (Line(points={{-59.5,50},{-34,50}}, color={0,0,0}));
  connect(transitionWithSignal2.outPort, liq.inPort[1]) annotation (Line(points={{51.5,10},
          {70,10},{70,-20},{-90,-20},{-90,50},{-81,50}},           color={0,0,0}));
  connect(transitionWithSignal1.outPort, sol.inPort[1])
    annotation (Line(points={{51.5,50},{79,50}}, color={0,0,0}));
  connect(sol.outPort[1], transitionWithSignal3.inPort)
    annotation (Line(points={{100.5,50},{126,50}}, color={0,0,0}));
  connect(transitionWithSignal3.outPort, trans.inPort[2]) annotation (Line(
        points={{131.5,50},{150,50},{150,72},{-8,72},{-8,50.25},{-1,50.25}},
        color={0,0,0}));
  connect(booleanExpression.y, transitionWithSignal2.condition)
    annotation (Line(points={{41,-10},{44,-10},{44,-2},{50,-2}},
                                                         color={255,0,255}));
  connect(booleanExpression1.y, transitionWithSignal3.condition) annotation (
      Line(points={{101,90},{110,90},{110,30},{130,30},{130,38}}, color={255,0,255}));
  connect(booleanExpression2.y, transitionWithSignal1.condition) annotation (
      Line(points={{21,90},{44,90},{44,32},{50,32},{50,38}}, color={255,0,255}));
  connect(booleanExpression3.y, transitionWithSignal.condition)
    annotation (Line(points={{-39,10},{-30,10},{-30,38}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end soc_calc;

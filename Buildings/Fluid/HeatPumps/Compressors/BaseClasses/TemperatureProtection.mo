within Buildings.Fluid.HeatPumps.Compressors.BaseClasses;
model TemperatureProtection
  "Temperature protection for heat pump compressor"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Temperature TConMax
    "Upper bound for condensor temperature";
  parameter Modelica.SIunits.Temperature TEvaMin
    "Lower bound for evaporator temperature";
  parameter Real dTHys(unit="K") = 5
    "Hysteresis interval width";
  parameter Boolean pre_y_start=false "Value of pre(y) of hysteresis at initial time";

  Modelica.Blocks.Interfaces.RealInput u "Compressor control signal"
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Modified compressor control signal"
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.RealInput TEva "Evaporator temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,106})));
  Modelica.Blocks.Interfaces.RealInput TCon "Condenser temperature" annotation (
     Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-106})));
  Modelica.Blocks.Logical.Switch switch
    "Switches control signal off when conditions not satisfied"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Logical.Hysteresis hysHig(uLow=0, uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for condensor upper bound temperature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Modelica.Blocks.Sources.Constant zero(k=0)
    "Zero control signal when check fails"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Hysteresis hysLow(uLow=0, uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for evaporator lower bound temperature"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Blocks.Sources.Constant TMax(k=TConMax)
    "Condensor maximum temperature"
    annotation (Placement(transformation(extent={{-86,-32},{-74,-20}})));
  Modelica.Blocks.Math.Add dTCon(k1=-1)
    "Difference between condenser temperature and its upper bound"
    annotation (Placement(transformation(extent={{-60,-10},{-40,-30}})));
  Modelica.Blocks.Math.Add dTEva(k1=-1)
    "Difference between evaporator temperature and its lower bound"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.Constant TMin(k=TEvaMin)
    "Evaporator minimum temperature"
    annotation (Placement(transformation(extent={{-86,20},{-74,32}})));
  Modelica.Blocks.MathBoolean.And
                              on(nu=3) "Compressor status"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));


  Modelica.Blocks.Logical.Hysteresis hysdTConEva(
    uLow=0,
    uHigh=dTHys,
    final pre_y_start=pre_y_start)
    "Hysteresis for temperature difference between evaporator and condenser"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Add dTEvaCon(k1=-1)
    "Difference between evaporator and condenser"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(zero.y,switch. u3) annotation (Line(points={{41,-30},{50,-30},{50,-8},
          {58,-8}},color={0,0,127}));
  connect(u, switch.u1) annotation (Line(points={{-106,0},{-100,0},{-100,40},{40,
          40},{40,8},{58,8}}, color={0,0,127}));
  connect(switch.y, y)
    annotation (Line(points={{81,0},{106,0}},         color={0,0,127}));
  connect(TMax.y, dTCon.u1) annotation (Line(points={{-73.4,-26},{-67.7,-26},{
          -62,-26}},
                 color={0,0,127}));
  connect(TMin.y, dTEva.u1) annotation (Line(points={{-73.4,26},{-67.7,26},{-62,
          26}}, color={0,0,127}));
  connect(dTEva.u2, TEva) annotation (Line(points={{-62,14},{-70,14},{-70,60},{
          0,60},{0,106}},
                    color={0,0,127}));
  connect(dTCon.u2, TCon) annotation (Line(points={{-62,-14},{-70,-14},{-70,-60},
          {0,-60},{0,-106}},color={0,0,127}));
  connect(dTEva.y, hysLow.u)
    annotation (Line(points={{-39,20},{-39,20},{-22,20}}, color={0,0,127}));
  connect(hysHig.u, dTCon.y)
    annotation (Line(points={{-22,-20},{-22,-20},{-39,-20}}, color={0,0,127}));
  connect(on.y, switch.u2)
    annotation (Line(points={{41.5,0},{41.5,0},{58,0}},
                                                    color={255,0,255}));
  connect(dTEvaCon.y, hysdTConEva.u)
    annotation (Line(points={{-39,0},{-32,0},{-22,0}}, color={0,0,127}));
  connect(dTEvaCon.u2, TCon) annotation (Line(points={{-62,-6},{-70,-6},{-70,
          -60},{0,-60},{0,-106}}, color={0,0,127}));
  connect(dTEvaCon.u1, TEva) annotation (Line(points={{-62,6},{-70,6},{-70,60},
          {0,60},{0,106}}, color={0,0,127}));
  connect(hysLow.y, on.u[1]) annotation (Line(points={{1,20},{10,20},{10,
          4.66667},{20,4.66667}}, color={255,0,255}));
  connect(hysdTConEva.y, on.u[2])
    annotation (Line(points={{1,0},{20,0}}, color={255,0,255}));
  connect(hysHig.y, on.u[3]) annotation (Line(points={{1,-20},{10,-20},{10,
          -4.66667},{20,-4.66667}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TemperatureProtection;

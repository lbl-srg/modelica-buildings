within Buildings.Examples;
model ControllerHeatingCooling "Controller for heating and cooling"

  Modelica.Blocks.Math.Gain heatGain(k=1/sensitivityGainHeat)
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Modelica.Blocks.Math.Gain coolAirGain(k=-designAirFlow)
    annotation (Placement(transformation(extent={{-116,20},{-96,40}})));
  Modelica.Blocks.Math.Feedback heatError
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Modelica.Blocks.Math.Feedback coolError
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  Modelica.Blocks.Nonlinear.Limiter limiterAirCool(
    uMax=designAirFlow,
    uMin=minAirFlow,
    y(start=minAirFlow))
    annotation (Placement(transformation(extent={{-84,20},{-64,40}})));
  Modelica.Blocks.Math.Gain coolGain(k=1/sensitivityGainCool)
    annotation (Placement(transformation(extent={{-152,20},{-132,40}})));
  Modelica.Blocks.Nonlinear.Limiter limiterHeat(uMin=0, uMax=1)
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  parameter Modelica.SIunits.MassFlowRate designAirFlow "Design airflow rate of system";
  parameter Modelica.SIunits.MassFlowRate minAirFlow "Minimum airflow rate of system";
  parameter Real sensitivityGainHeat(unit="K") =  1 "Gain sensitivity on heating controller";
  parameter Real sensitivityGainCool(unit="K") =  0.3 "Gain sensitivity on cooling controller";
  Modelica.Blocks.Interfaces.RealInput TcoolSet "Zone cooling setpoint"
                                                annotation (Placement(
        transformation(rotation=0, extent={{-210,70},{-190,90}})));
  Modelica.Blocks.Interfaces.RealInput Tmea
    "Zone temperature measurement"          annotation (Placement(
        transformation(rotation=0, extent={{-210,-22},{-190,-2}})));
  Modelica.Blocks.Interfaces.RealInput TheatSet "Zone heating setpoint"
                                                annotation (Placement(
        transformation(rotation=0, extent={{-210,120},{-190,140}})));
  Modelica.Blocks.Interfaces.RealOutput fanSet(start=minAirFlow)
    "Control signal for fan"
    annotation (Placement(transformation(rotation=0, extent={{10,-10},{30,
            10}})));
  Modelica.Blocks.Interfaces.RealOutput heaterSet
    "Control signal for heating coil"             annotation (Placement(
        transformation(rotation=0, extent={{10,110},{30,130}})));
  Modelica.Blocks.Interfaces.RealOutput coolSignal "Cooling mode"
                                                  annotation (Placement(
        transformation(rotation=0, extent={{10,70},{30,90}})));
  Buildings.Utilities.Math.SmoothMax smoothMax(deltaX=1)
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Math.Sign sign1
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
  connect(heatError.y,heatGain. u) annotation (Line(points={{-141,130},{-141,130},
          {-122,130}}, color={0,0,127}));
  connect(coolAirGain.y,limiterAirCool. u)
    annotation (Line(points={{-95,30},{-92,30},{-90,30},{-86,30}},
                                                 color={0,0,127}));
  connect(coolError.y,coolGain. u)
    annotation (Line(points={{-161,30},{-154,30}}, color={0,0,127}));
  connect(coolAirGain.u,coolGain. y)
    annotation (Line(points={{-118,30},{-131,30}}, color={0,0,127}));
  connect(TcoolSet, coolError.u1) annotation (Line(points={{-200,80},{
          -184,80},{-184,30},{-178,30}},
                          color={0,0,127}));
  connect(Tmea, coolError.u2) annotation (Line(points={{-200,-12},{-200,-12},
          {-170,-12},{-170,22}}, color={0,0,127}));
  connect(TheatSet, heatError.u1)
    annotation (Line(points={{-200,130},{-158,130}}, color={0,0,127}));
  connect(Tmea, heatError.u2) annotation (Line(points={{-200,-12},{-200,-12},
          {-170,-12},{-150,-12},{-150,122}}, color={0,0,127}));
  connect(heatGain.y, limiterHeat.u) annotation (Line(points={{-99,130},{
          -76,130},{-76,120},{-54,120},{-62,120}},
                               color={0,0,127}));
  connect(limiterHeat.y, heaterSet) annotation (Line(points={{-39,120},{
          20,120}},       color={0,0,127}));
  connect(limiterAirCool.y, fanSet) annotation (Line(points={{-63,30},{-44,
          30},{-44,0},{20,0}}, color={0,0,127}));
  connect(const.y, smoothMax.u2) annotation (Line(points={{-59,60},{-52,
          60},{-52,74},{-42,74}}, color={0,0,127}));
  connect(sign1.u, limiterAirCool.u) annotation (Line(points={{-82,90},{
          -90,90},{-90,30},{-86,30}}, color={0,0,127}));
  connect(sign1.y, smoothMax.u1) annotation (Line(points={{-59,90},{-52,
          90},{-52,86},{-42,86}}, color={0,0,127}));
  connect(smoothMax.y, coolSignal)
    annotation (Line(points={{-19,80},{20,80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-190,-40},{10,160}})), Icon(
        coordinateSystem(extent={{-190,-40},{10,160}})));
end ControllerHeatingCooling;

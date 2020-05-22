within Buildings.Applications.DHC.CentralPlants.Gen1st.Controls;
model ChilledWaterPumpSpeed
  "Controller for variable speed chilled water pumps"
  parameter Modelica.SIunits.Pressure dpSetPoi "Pressure difference setpoint";
  parameter Real tWai = 300 "Waiting time";
  DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage pumStaCon(tWai=tWai)
    "Chilled water pump staging control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput dpMea "Measured pressure difference"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Math.Product pumSpe[2] "Output pump speed"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[2] "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.Continuous.LimPID conPID(
    reverseAction=false,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=240,
    k=0.000001)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.RealExpression dpSet(y=dpSetPoi)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealInput masFloPum
    "Total mass flowrate in the variable speed pumps"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
equation
  connect(pumStaCon.masFloPum, masFloPum) annotation (Line(points={{-12,8},{-20,
          8},{-20,40},{-120,40}}, color={0,0,127}));
  connect(dpMea, conPID.u_m) annotation (Line(points={{-120,-40},{-50,-40},{-50,
          -12}}, color={0,0,127}));
  connect(dpSet.y, conPID.u_s)
    annotation (Line(points={{-79,0},{-62,0}}, color={0,0,127}));
  connect(conPID.y, pumStaCon.speSig) annotation (Line(points={{-39,0},{-20,0},
          {-20,4},{-12,4}}, color={0,0,127}));
  connect(pumStaCon.y, pumSpe.u1)
    annotation (Line(points={{11,0},{28,0},{28,6},{38,6}}, color={0,0,127}));
  connect(conPID.y, pumSpe[1].u2) annotation (Line(points={{-39,0},{-30,0},{-30,
          -20},{28,-20},{28,-6},{38,-6}}, color={0,0,127}));
  connect(conPID.y, pumSpe[2].u2) annotation (Line(points={{-39,0},{-30,0},{-30,
          -20},{28,-20},{28,-6},{38,-6}}, color={0,0,127}));
  connect(pumSpe.y, y)
    annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}),             Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end ChilledWaterPumpSpeed;

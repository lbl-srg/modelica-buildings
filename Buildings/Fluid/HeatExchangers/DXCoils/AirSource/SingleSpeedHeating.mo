within Buildings.Fluid.HeatExchangers.DXCoils.AirSource;
model SingleSpeedHeating
  "Single speed DX heating coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXHeatingCoil(
    dxCoi(final variableSpeedCoil=false,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCapacityAirSource
      coiCap),
    computeReevaporation=false,
    use_mCon_flow=false);

  Modelica.Blocks.Sources.Constant speRat(
    final k=1)
    "Speed ratio 1 constant source"
    annotation (Placement(transformation(extent={{-56,58},{-44,70}})));

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Buildings.Fluid.Sensors.MassFraction senMasFra(
    redeclare package Medium = Medium)
    "Mass fraction sensor for detecting humidity ratio of inlet air"
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaOn
    "Convert Boolean enable signal to Real value 1, disable to Real value 0"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0)
    "On/off switch"
    annotation (Placement(transformation(extent={{-56,74},{-44,86}})));

initial equation
  assert(datCoi.nSta == 1, "Must have one stage only for single speed performance data.");

equation
  connect(speRat.y,dxCoi.speRat)  annotation (Line(
      points={{-43.4,64},{-40,64},{-40,59.6},{-21,59.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on, onSwi.u) annotation (Line(
      points={{-110,80},{-57.2,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y,dxCoi.stage)  annotation (Line(
      points={{-43.4,80},{-34,80},{-34,62},{-21,62}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(TOut, dxCoi.TEvaIn) annotation (Line(points={{-110,30},{-92,30},{-92,
          52},{-21,52}}, color={0,0,127}));
  connect(senMasFra.port, port_a) annotation (Line(points={{-50,6},{-80,6},{-80,
          0},{-100,0}}, color={0,127,255}));
  connect(senMasFra.X, defCap.XConIn) annotation (Line(points={{-39,16},{26,16},
          {26,-54},{59,-54}}, color={0,0,127}));
  connect(on, booToReaOn.u) annotation (Line(points={{-110,80},{-94,80},{-94,
          -80},{-22,-80}},
                      color={255,0,255}));
  connect(booToReaOn.y, defCap.uSpe) annotation (Line(points={{2,-80},{56,-80},
          {56,-38},{59,-38}}, color={0,0,127}));
  annotation (defaultComponentName="sinSpeDXHea", Documentation(info="<html>
<p>
This model can be used to simulate an air-source DX heating coil with single speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 8, 2023, by Xing Lu and Karthik Devaprasad:<br/>
Initial implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-140,132},{-96,112}},
          textColor={0,0,255},
          textString="on")}));
end SingleSpeedHeating;

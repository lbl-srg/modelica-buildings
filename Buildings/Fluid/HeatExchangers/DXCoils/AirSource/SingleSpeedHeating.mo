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
    annotation (Placement(transformation(extent={{-86,100},{-74,112}})));

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}}),
      iconTransformation(extent={{-120,100},{-100,120}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaOn
    "Convert Boolean enable signal to Real value 1, disable to Real value 0"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));

  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0)
    "On/off switch"
    annotation (Placement(transformation(extent={{-60,114},{-48,126}})));

initial equation
  assert(datCoi.nSta == 1, "Must have one stage only for single speed performance data.");

equation
  connect(speRat.y,dxCoi.speRat)  annotation (Line(
      points={{-73.4,106},{-60,106},{-60,59.6},{-21,59.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on, onSwi.u) annotation (Line(
      points={{-110,120},{-61.2,120}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y,dxCoi.stage)  annotation (Line(
      points={{-47.4,120},{-38,120},{-38,62},{-21,62}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(TOut, dxCoi.TEvaIn) annotation (Line(points={{-110,30},{-92,30},{-92,
          52},{-21,52}}, color={0,0,127}));
  connect(on, booToReaOn.u) annotation (Line(points={{-110,120},{-94,120},{-94,140},
          {-22,140}}, color={255,0,255}));
  connect(booToReaOn.y, defCap.uSpe) annotation (Line(points={{2,140},{50,140},{
          50,100},{61,100}},  color={0,0,127}));
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
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={Text(
          extent={{-140,142},{-100,122}},
          textColor={0,0,255},
          textString="on")}),
    Diagram(coordinateSystem(extent={{-100,-60},{100,160}})));
end SingleSpeedHeating;

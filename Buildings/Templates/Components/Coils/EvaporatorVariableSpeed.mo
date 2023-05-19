within Buildings.Templates.Components.Coils;
model EvaporatorVariableSpeed
  "Evaporator coil with variable speed compressor"
  extends Buildings.Templates.Components.Interfaces.PartialCoil(
    final typ=Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed,
    final typVal=Buildings.Templates.Components.Types.Valve.None);

  parameter Boolean have_dryCon = true
    "Set to true for air-cooled condenser, false for evaporative condenser";

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.VariableSpeed hex(
    redeclare final package Medium = MediumAir,
    final datCoi=dat.datCoi,
    final minSpeRat=dat.datCoi.minSpeRat,
    final dp_nominal=dpAir_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversalAir,
    final show_T=show_T)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Routing.RealPassThrough TWetBul if not have_dryCon
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Modelica.Blocks.Routing.RealPassThrough TDry if have_dryCon
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
equation
  connect(port_a, hex.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(hex.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(busWea.TWetBul, TWetBul.u) annotation (Line(
      points={{-60,100},{-60,60},{-52,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busWea.TDryBul, TDry.u) annotation (Line(
      points={{-60,100},{-60,20},{-52,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TWetBul.y, hex.TConIn) annotation (Line(points={{-29,60},{-20,60},{-20,3},
          {-11,3}}, color={0,0,127}));
  connect(TDry.y, hex.TConIn) annotation (Line(points={{-29,20},{-20,20},{-20,3},
          {-11,3}}, color={0,0,127}));
  connect(bus.y, hex.speRat) annotation (Line(
      points={{0,100},{0,20},{-16,20},{-16,8},{-11,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Diagram(
        coordinateSystem(preserveAspectRatio=false)), Documentation(info="<html>
<p>
This is a model for a direct expansion cooling coil with a
variable speed compressor.
The compressor speed is modulated with the fractional speed
signal <code>y</code> (real between <code>0</code> and <code>1</code>).
</p>
</html>"));
end EvaporatorVariableSpeed;

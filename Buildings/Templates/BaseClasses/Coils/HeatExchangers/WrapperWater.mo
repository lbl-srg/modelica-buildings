within Buildings.Templates.BaseClasses.Coils.HeatExchangers;
model WrapperWater "Wrapper class for water-based coils"
  extends Buildings.Templates.Interfaces.HeatExchangerWater;

  WetCoilCounterFlow wet(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2) if typ==Buildings.Templates.Types.HeatExchangerWater.WetCoilCounterFlow
    "Wet coil"
    annotation (Placement(transformation(extent={{-10,44},{10,64}})));
  DryCoilEffectivenessNTU dry(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2) if typ==Buildings.Templates.Types.HeatExchangerWater.DryCoilEffectivenessNTU
    "Dry coil"
    annotation (Placement(transformation(extent={{-10,-64},{10,-44}})));
equation
  connect(dry.port_b1, port_b1) annotation (Line(points={{10,-48},{60,-48},{60,60},
          {100,60}}, color={0,127,255}));
  connect(port_a1, wet.port_a1)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(wet.port_b1, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(port_a1, dry.port_a1) annotation (Line(points={{-100,60},{-60,60},{-60,
          -48},{-10,-48}}, color={0,127,255}));
  connect(port_b2, dry.port_b2)
    annotation (Line(points={{-100,-60},{-10,-60}}, color={0,127,255}));
  connect(dry.port_a2, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(port_b2, wet.port_b2) annotation (Line(points={{-100,-60},{-40,-60},{-40,
          48},{-10,48}}, color={0,127,255}));
  connect(wet.port_a2, port_a2) annotation (Line(points={{10,48},{40,48},{40,-60},
          {100,-60}}, color={0,127,255}));
end WrapperWater;

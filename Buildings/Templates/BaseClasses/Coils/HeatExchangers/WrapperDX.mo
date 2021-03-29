within Buildings.Templates.BaseClasses.Coils.HeatExchangers;
model WrapperDX "Wrapper class for DX coils"
  extends Buildings.Templates.Interfaces.HeatExchangerDX;

  replaceable DXMultiStage mul(
    redeclare final package Medium = Medium,
    final dp_nominal=dp_nominal) if
      typ==Buildings.Templates.Types.HeatExchangerDX.DXMultiStage
    "Multistage"
    annotation (
      Dialog(enable=typ==Buildings.Templates.Types.HeatExchangerDX.DXMultiStage),
      Placement(transformation(extent={{-40,30},{-20,50}})));
  replaceable DXVariableSpeed var(
    redeclare final package Medium = Medium,
    final dp_nominal=dp_nominal) if
      typ==Buildings.Templates.Types.HeatExchangerDX.DXVariableSpeed
    "Variable speed"
    annotation (
      Dialog(enable=typ==Buildings.Templates.Types.HeatExchangerDX.DXVariableSpeed),
      Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(port_a, var.port_a)
    annotation (Line(points={{-100,0},{20,0}}, color={0,127,255}));
  connect(var.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(port_a, mul.port_a) annotation (Line(points={{-100,0},{-60,0},{-60,40},
          {-40,40}}, color={0,127,255}));
  connect(mul.port_b, port_b) annotation (Line(points={{-20,40},{80,40},{80,0},{
          100,0}}, color={0,127,255}));
  connect(weaBus, mul.weaBus) annotation (Line(
      points={{-60,100},{-60,80},{-36,80},{-36,50}},
      color={255,204,51},
      thickness=0.5));
  connect(mul.busCon, busCon) annotation (Line(
      points={{-30,50},{-30,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(var.weaBus, weaBus) annotation (Line(
      points={{24,10},{24,60},{-60,60},{-60,100}},
      color={255,204,51},
      thickness=0.5));
  connect(busCon, var.busCon) annotation (Line(
      points={{0,100},{0,80},{30,80},{30,10}},
      color={255,204,51},
      thickness=0.5));
end WrapperDX;

within Buildings.Templates.BaseClasses.Coils;
model Wrapper "Wrapper class for coil models"
  extends Buildings.Templates.Interfaces.Coil(
    final have_weaBus=typ==Buildings.Templates.Types.Coil.DirectExpansion,
    final have_sou=typ==Buildings.Templates.Types.Coil.WaterBased);

  replaceable DirectExpansion dx(
    final typHexDX=typHexDX,
    final typHexWat=typHexWat,
    final typAct=typAct,
    redeclare final package MediumAir = MediumAir,
    final mAir_flow_nominal=mAir_flow_nominal,
    final dpAir_nominal=dpAir_nominal) if typ==Buildings.Templates.Types.Coil.DirectExpansion
    "Direct expansion"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  None non(
    final typHexDX=typHexDX,
    final typHexWat=typHexWat,
    final typAct=typAct,
    redeclare final package MediumAir = MediumAir) if typ==Buildings.Templates.Types.Coil.None
    "No coil"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  replaceable WaterBased wat(
    final typHexDX=typHexDX,
    final typHexWat=typHexWat,
    final typAct=typAct,
    redeclare final package MediumSou = MediumSou,
    redeclare final package MediumAir = MediumAir,
    final mAir_flow_nominal=mAir_flow_nominal,
    final dpAir_nominal=dpAir_nominal) if typ==Buildings.Templates.Types.Coil.WaterBased
    "Water-based"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, wat.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(wat.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(busCon, wat.busCon) annotation (Line(
      points={{0,100},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(dx.busCon, busCon) annotation (Line(
      points={{-70,70},{-70,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(dx.weaBus, weaBus) annotation (Line(
      points={{-76,70},{-76,100},{-60,100}},
      color={255,204,51},
      thickness=0.5));
  connect(port_a, dx.port_a) annotation (Line(points={{-100,0},{-90,0},{-90,60},
          {-80,60}}, color={0,127,255}));
  connect(port_a, non.port_a) annotation (Line(points={{-100,0},{-60,0},{-60,40},
          {-40,40}}, color={0,127,255}));
  connect(non.port_b, port_b) annotation (Line(points={{-20,40},{80,40},{80,0},{
          100,0}}, color={0,127,255}));
  connect(dx.port_b, port_b) annotation (Line(points={{-60,60},{80,60},{80,0},{100,
          0}}, color={0,127,255}));
  connect(port_aSou, wat.port_aSou) annotation (Line(points={{-40,-100},{-40,-20},
          {-4,-20},{-4,-10}}, color={0,127,255}));
  connect(wat.port_bSou, port_bSou) annotation (Line(points={{4,-10},{4,-20},{40,
          -20},{40,-100}}, color={0,127,255}));
end Wrapper;

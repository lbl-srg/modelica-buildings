within Buildings.Fluid.Storage.Plant;
model CDWPlaceholder "Placeholder model for the CDW loop"
  extends Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=1);

  Buildings.Fluid.Sources.Boundary_pT souCDW(
    redeclare final package Medium = Medium,
    final p=800000,
    final T=32 + 273.15,
    nPorts=1) "Source representing CDW supply line" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,70})));
  Modelica.Blocks.Sources.Constant set_mCDW_flow(k=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,30})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSouCDW(
    redeclare package Medium = Medium,
    control_m_flow=true,
    control_dp=false,
    m_flow_small=1E-3)
    "Flow source for the CDW loop"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,0})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW(
    redeclare final package Medium = Medium,
    final p=300000,
    final T=37 + 273.15,
    nPorts=1) "Sink representing CDW return line" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={50,70})));
equation
  connect(souCDW.ports[1],ideSouCDW. port_a)
    annotation (Line(points={{-50,60},{-50,0},{-60,0}},
                                                     color={0,127,255}));
  connect(set_mCDW_flow.y,ideSouCDW. m_flow_in) annotation (Line(points={{-79,30},
          {-64,30},{-64,8}},        color={0,0,127}));
  connect(ideSouCDW.port_b, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(sinCDW.ports[1], port_b)
    annotation (Line(points={{50,60},{50,0},{100,0}}, color={0,127,255}));
  annotation (Icon(graphics={Rectangle(extent={{-100,98},{-60,-100}},
                                                                   lineColor={28,
              108,200}), Text(
          extent={{-80,40},{80,-20}},
          textColor={28,108,200},
          textString="CDW"), Rectangle(extent={{60,100},{100,-100}},
                                                                   lineColor={28,
              108,200})}));
end CDWPlaceholder;

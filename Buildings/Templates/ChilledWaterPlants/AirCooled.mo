within Buildings.Templates.ChilledWaterPlants;
model AirCooled "Air-cooled chiller plant"
  extends
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop(
    redeclare replaceable package MediumCon=Buildings.Media.Air,
    final typChi=Buildings.Templates.Components.Types.Chiller.AirCooled,
    final typValCooInlIso=Buildings.Templates.Components.Types.Valve.None,
    final typValCooOutIso=Buildings.Templates.Components.Types.Valve.None);

  // Air loop

  Fluid.Sources.Boundary_pT bouCon(
    redeclare final package Medium = MediumCon,
    final nPorts=1)
    "Air pressure boundary condition"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-100,0})));
  Fluid.Sources.MassFlowSource_WeatherData souAir[nChi](
    redeclare each final package Medium = MediumCon,
    each final use_m_flow_in=true,
    each final nPorts=1)
    "Air flow source"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-100,-100})));
  Controls.OBC.CDL.Conversions.BooleanToReal y1Chi[nChi]
    "Convert chiller Start/Stop signal into real value"
    annotation (Placement(transformation(extent={{-230,130},{-210,150}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter mCon_flow[nChi](
    k=dat.chi.mConChi_flow_nominal)
    "Compute air mass flow rate at condenser"
    annotation (Placement(transformation(extent={{-188,130},{-168,150}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus" annotation (Placement(transformation(extent={{-280,
            120},{-240,160}}),
                          iconTransformation(extent={{-756,-40},{-716,0}})));
equation
  for i in 1:nChi loop
      connect(busWea, souAir[i].weaBus) annotation (Line(
      points={{0,280},{0,260},{-140,260},{-140,-100},{-136,-100},{-136,-100.2},
            {-110,-100.2}},
      color={255,204,51},
      thickness=0.5));
  end for;
  connect(outConChi.port_b, bouCon.ports[1])
    annotation (Line(points={{-80,0},{-90,0},{-90,-8.88178e-16}},
                                                color={0,127,255}));
  connect(souAir.ports[1], chi.ports_aCon)
    annotation (Line(points={{-90,-100},{-60,-100}},  color={0,127,255}));

  connect(y1Chi.y, mCon_flow.u)
    annotation (Line(points={{-208,140},{-190,140}}, color={0,0,127}));
  connect(mCon_flow.y, souAir.m_flow_in) annotation (Line(points={{-166,140},{
          -160,140},{-160,-108},{-110,-108}},
                                         color={0,0,127}));
  connect(busChi.y1, y1Chi.u) annotation (Line(
      points={{-260,140},{-232,140}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.chi, busChi) annotation (Line(
      points={{-300,140},{-260,140}},
      color={255,204,51},
      thickness=0.5));
end AirCooled;

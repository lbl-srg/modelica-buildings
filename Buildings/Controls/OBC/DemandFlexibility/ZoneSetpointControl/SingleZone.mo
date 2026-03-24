within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl;
block SingleZone

  parameter Boolean demFleHeaAct=true "the demand flexibility for heating is active";
    parameter Boolean demFleCooAct=true "the demand flexibility for cooling is active";

       parameter Real delChaSheHea=-1
    "Change amount for ratchet for heating";

   parameter Real delChaRebHea=1
    "Change amount for rebound for heating";
        parameter Real samPerPreHea(unit="s")=300
    "Sample period for preheat";
            parameter Real samPerNomHea(unit="s")=300
    "Sample period for the nominal condition for heating";
        parameter Real samPerSheHea(unit="s")=300
    "Sample period for ratche for heatingt";
        parameter Real samPerRebHea(unit="s")=300
    "Sample period for rebound for heating";

    parameter Real delSheThoHea=0.5
    "Threshold below which heating ratcheting is triggerd. This is an absolute value, so it is always positive";

        parameter Real delSheThoCoo=0.5
    "Threshold below which cooling ratcheting is triggerd. This is an absolute value, so it is always positive";

       parameter Real delChaSheCoo=1
    "Change amount for ratchet for cooling";

   parameter Real delChaRebCoo=-1
    "Change amount for rebound for cooling";
        parameter Real samPerPreCoo(unit="s")=300
    "Sample period for precool";
            parameter Real samPerNomCoo(unit="s")=300
    "Sample period for the nominal condition for cooling";
        parameter Real samPerSheCoo(unit="s")=300
    "Sample period for ratchet for cooling";
        parameter Real samPerRebCoo(unit="s")=300
    "Sample period for rebound for cooling";

  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-200,64},{-160,104}}),
        iconTransformation(extent={{-200,66},{-160,106}})));
  CDL.Interfaces.RealInput TSetTarPreHea "setpoint target for preheat"
    annotation (Placement(transformation(extent={{-200,-68},{-160,-28}}),
        iconTransformation(extent={{-200,-68},{-160,-28}})));
  CDL.Interfaces.RealInput TSetTarSheHea "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-200,-104},{-160,-64}}),
        iconTransformation(extent={{-200,-104},{-160,-64}})));
  CDL.Interfaces.RealInput TSetNomHea "nominal setpoint"
    annotation (Placement(transformation(extent={{-200,-138},{-160,-98}}),
        iconTransformation(extent={{-200,-138},{-160,-98}})));
  CDL.Interfaces.RealInput TSetCurHea "current setpoint"
    annotation (Placement(transformation(extent={{-200,26},{-160,66}}),
        iconTransformation(extent={{-200,26},{-160,66}})));
  CDL.Interfaces.RealInput TSetTarPreCoo "setpoint target for precool"
    annotation (Placement(transformation(extent={{-200,-174},{-160,-134}}),
        iconTransformation(extent={{-200,-174},{-160,-134}})));
  CDL.Interfaces.RealInput TSetTarSheCoo "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-200,-214},{-160,-174}}),
        iconTransformation(extent={{-200,-214},{-160,-174}})));
  CDL.Interfaces.RealInput TSetNomCoo "nominal setpoint"
    annotation (Placement(transformation(extent={{-200,-248},{-160,-208}}),
        iconTransformation(extent={{-200,-248},{-160,-208}})));
  CDL.Interfaces.RealOutput TSetComHea "setpoint command" annotation (Placement(
        transformation(extent={{130,0},{170,40}}),  iconTransformation(extent={{130,0},
            {170,40}})));
  CDL.Interfaces.RealOutput TSetComCoo "setpoint command"
    annotation (Placement(transformation(extent={{130,-198},{170,-158}}),
        iconTransformation(extent={{130,-198},{170,-158}})));
  CDL.Interfaces.RealInput TSetCurCoo "current setpoint"
    annotation (Placement(transformation(extent={{-200,-32},{-160,8}}),
        iconTransformation(extent={{-200,-32},{-160,8}})));
  CDL.Interfaces.RealInput TCur "current zone temperature"
    annotation (Placement(transformation(extent={{-200,-4},{-160,36}}),
        iconTransformation(extent={{-200,-4},{-160,36}})));
  Subsequences.BaseTemperatureSetpointElements.DualTemperatureSetpoint
    dualTemperatureSetpoint(
    demFleHeaAct=demFleHeaAct,
    demFleCooAct=demFleCooAct,
    delChaSheHea=delChaSheHea,
    delChaRebHea=delChaRebHea,
    samPerPreHea=samPerPreHea,
    samPerNomHea=samPerNomHea,
    samPerSheHea=samPerSheHea,
    samPerRebHea=samPerRebHea,
    delSheThoHea=delSheThoHea,
    delSheThoCoo=delSheThoCoo,
    delChaSheCoo=delChaSheCoo,
    delChaRebCoo=delChaRebCoo,
    samPerPreCoo=samPerPreCoo,
    samPerNomCoo=samPerNomCoo,
    samPerSheCoo=samPerSheCoo,
    samPerRebCoo=samPerRebCoo)
    annotation (Placement(transformation(extent={{-34,-150},{68,2}})));
  CDL.Logical.Sources.Constant con1(k=true)
    annotation (Placement(transformation(extent={{-92,94},{-72,114}})));
equation
  connect(con1.y, dualTemperatureSetpoint.have_priCoo) annotation (Line(points=
          {{-70,104},{-56,104},{-56,-14},{-44.2,-14}}, color={255,0,255}));
  connect(uMod, dualTemperatureSetpoint.uMod) annotation (Line(points={{-180,84},
          {-68,84},{-68,-28},{-44.2,-28},{-44.2,-27.6}}, color={255,127,0}));
  connect(TSetCurHea, dualTemperatureSetpoint.TSetCurHea) annotation (Line(
        points={{-180,46},{-76,46},{-76,-38},{-44.2,-38},{-44.2,-38.8}}, color=
          {0,0,127}));
  connect(TCur, dualTemperatureSetpoint.TCur) annotation (Line(points={{-180,16},
          {-86,16},{-86,-50.8},{-44.2,-50.8}}, color={0,0,127}));
  connect(TSetCurCoo, dualTemperatureSetpoint.TSetCurCoo) annotation (Line(
        points={{-180,-12},{-98,-12},{-98,-62},{-44.2,-62}}, color={0,0,127}));
  connect(TSetTarSheHea, dualTemperatureSetpoint.TSetTarSheHea) annotation (
      Line(points={{-180,-84},{-141,-84},{-141,-90.8},{-44.2,-90.8}}, color={0,
          0,127}));
  connect(TSetNomHea, dualTemperatureSetpoint.TSetNomHea) annotation (Line(
        points={{-180,-118},{-114,-118},{-114,-104.4},{-44.2,-104.4}}, color={0,
          0,127}));
  connect(TSetTarPreCoo, dualTemperatureSetpoint.TSetTarPreCoo) annotation (
      Line(points={{-180,-154},{-94,-154},{-94,-118.8},{-44.2,-118.8}}, color={
          0,0,127}));
  connect(TSetTarSheCoo, dualTemperatureSetpoint.TSetTarSheCoo) annotation (
      Line(points={{-180,-194},{-74,-194},{-74,-134},{-44.2,-134},{-44.2,-134.8}},
        color={0,0,127}));
  connect(TSetNomCoo, dualTemperatureSetpoint.TSetNomCoo) annotation (Line(
        points={{-180,-228},{-60,-228},{-60,-148},{-44.2,-148},{-44.2,-148.4}},
        color={0,0,127}));
  connect(dualTemperatureSetpoint.TSetComHea, TSetComHea) annotation (Line(
        points={{78.2,-38},{111.1,-38},{111.1,20},{150,20}}, color={0,0,127}));
  connect(con1.y, dualTemperatureSetpoint.have_priHea) annotation (Line(points=
          {{-70,104},{-56,104},{-56,-1.2},{-44.2,-1.2}}, color={255,0,255}));
  connect(dualTemperatureSetpoint.TSetComCoo, TSetComCoo) annotation (Line(
        points={{78.2,-116.4},{78.2,-116},{110,-116},{110,-178},{150,-178}},
        color={0,0,127}));
  connect(TSetTarPreHea, dualTemperatureSetpoint.TSetTarPreHea) annotation (
      Line(points={{-180,-48},{-124,-48},{-124,-76},{-44.2,-76},{-44.2,-76.4}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -260},{130,120}},
        grid={2,2})),     Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-260},{130,120}},
        grid={2,2})),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This is a utility block that controls both the cooling setpoint and the heating setpoint for a single building zone, based on the current mode uMod: -1 = pre-cool/pre-heat mode, 1 = load shed mode, 2 = load rebound mode, and 0 = baseline mode. </span></p>
<p><span style=\"font-size: 9pt;\">The heating setpoint and the cooling setpoint are controlled independently.</span></p>
</html>"));
end SingleZone;

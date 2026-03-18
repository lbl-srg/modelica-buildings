within Buildings.Controls.OBC.DemandFlexibility;
block SingleZoneSetpointControl

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
    annotation (Placement(transformation(extent={{-140,34},{-100,74}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.RealInput TSetTarPreHea "setpoint target for preheat"
    annotation (Placement(transformation(extent={{-140,-96},{-100,-56}}),
        iconTransformation(extent={{-140,-96},{-100,-56}})));
  CDL.Interfaces.RealInput TSetTarSheHea "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-132},{-100,-92}}),
        iconTransformation(extent={{-140,-132},{-100,-92}})));
  CDL.Interfaces.RealInput TSetNomHea "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-166},{-100,-126}}),
        iconTransformation(extent={{-140,-166},{-100,-126}})));
  CDL.Interfaces.RealInput TSetCurHea "current setpoint"
    annotation (Placement(transformation(extent={{-140,-2},{-100,38}}),
        iconTransformation(extent={{-140,-2},{-100,38}})));
  CDL.Interfaces.RealInput TSetTarPreCoo "setpoint target for precool"
    annotation (Placement(transformation(extent={{-140,-202},{-100,-162}})));
  CDL.Interfaces.RealInput TSetTarSheCoo "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-140,-242},{-100,-202}})));
  CDL.Interfaces.RealInput TSetNomCoo "nominal setpoint"
    annotation (Placement(transformation(extent={{-140,-276},{-100,-236}})));
  CDL.Interfaces.RealOutput TSetComHea "setpoint command" annotation (Placement(
        transformation(extent={{130,0},{170,40}}),  iconTransformation(extent={{130,0},
            {170,40}})));
  CDL.Interfaces.RealOutput TSetComCoo "setpoint command"
    annotation (Placement(transformation(extent={{130,-198},{170,-158}}),
        iconTransformation(extent={{130,-198},{170,-158}})));
  CDL.Interfaces.RealInput TSetCurCoo "current setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput TCur "current zone temperature"
    annotation (Placement(transformation(extent={{-140,-32},{-100,8}}),
        iconTransformation(extent={{-140,-32},{-100,8}})));
  Subsequences.SingleZoneSetpointControlBase singleZoneSetpointControlBase(
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
    annotation (Placement(transformation(extent={{-34,-140},{68,12}})));
  CDL.Logical.Sources.Constant con1(k=true)
    annotation (Placement(transformation(extent={{-74,72},{-54,92}})));
equation
  connect(con1.y, singleZoneSetpointControlBase.have_priHea) annotation (Line(
        points={{-52,82},{-52,48},{-44.2,48},{-44.2,8.8}}, color={255,0,255}));
  connect(con1.y, singleZoneSetpointControlBase.have_priCoo) annotation (Line(
        points={{-52,82},{-48,82},{-48,-4},{-44.2,-4}}, color={255,0,255}));
  connect(uMod, singleZoneSetpointControlBase.uMod) annotation (Line(points={{
          -120,54},{-80,54},{-80,-17.6},{-44.2,-17.6}}, color={255,127,0}));
  connect(TSetCurHea, singleZoneSetpointControlBase.TSetCurHea) annotation (
      Line(points={{-120,18},{-82,18},{-82,-28.8},{-44.2,-28.8}}, color={0,0,
          127}));
  connect(TCur, singleZoneSetpointControlBase.TCur) annotation (Line(points={{
          -120,-12},{-82,-12},{-82,-40.8},{-44.2,-40.8}}, color={0,0,127}));
  connect(TSetCurCoo, singleZoneSetpointControlBase.TSetCurCoo) annotation (
      Line(points={{-120,-40},{-82,-40},{-82,-52},{-44.2,-52}}, color={0,0,127}));
  connect(TSetTarPreHea, singleZoneSetpointControlBase.TSetTarPreHea)
    annotation (Line(points={{-120,-76},{-84,-76},{-84,-66.4},{-44.2,-66.4}},
        color={0,0,127}));
  connect(TSetTarSheHea, singleZoneSetpointControlBase.TSetTarSheHea)
    annotation (Line(points={{-120,-112},{-83,-112},{-83,-80.8},{-44.2,-80.8}},
        color={0,0,127}));
  connect(TSetNomHea, singleZoneSetpointControlBase.TSetNomHea) annotation (
      Line(points={{-120,-146},{-82,-146},{-82,-94.4},{-44.2,-94.4}}, color={0,
          0,127}));
  connect(TSetTarPreCoo, singleZoneSetpointControlBase.TSetTarPreCoo)
    annotation (Line(points={{-120,-182},{-82,-182},{-82,-108.8},{-44.2,-108.8}},
        color={0,0,127}));
  connect(TSetTarSheCoo, singleZoneSetpointControlBase.TSetTarSheCoo)
    annotation (Line(points={{-120,-222},{-120,-173},{-44.2,-173},{-44.2,-124.8}},
        color={0,0,127}));
  connect(TSetNomCoo, singleZoneSetpointControlBase.TSetNomCoo) annotation (
      Line(points={{-120,-256},{-78,-256},{-78,-138.4},{-44.2,-138.4}}, color={
          0,0,127}));
  connect(singleZoneSetpointControlBase.TSetComHea, TSetComHea) annotation (
      Line(points={{78.2,-28},{111.1,-28},{111.1,20},{150,20}}, color={0,0,127}));
  connect(singleZoneSetpointControlBase.TSetComCoo, TSetComCoo) annotation (
      Line(points={{78.2,-107.2},{78.2,-141.6},{150,-141.6},{150,-178}}, color=
          {0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -260},{130,120}},
        grid={2,2})),     Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-260},{130,120}},
        grid={2,2})),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This is a utility block that controls both the cooling setpoint and the heating setpoint for a single building zone. It works by having the &quot;has_priHea&quot; and &quot;has_priCoo&quot; to True. We still maintain the &quot;has_pri&quot; variables to be inputs because in the MultipleZoneSetpointControl, it references this block. </span></p>
</html>"));
end SingleZoneSetpointControl;

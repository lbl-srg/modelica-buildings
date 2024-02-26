within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model StageChangeCommand
  parameter Real cp_default(final unit="J/(kg.K)")=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Default specific heat capacity"
    annotation (Dialog(group="Configuration", enable=false));
  parameter Real rho_default(final unit="kg/m3")=
    Buildings.Media.Water.d_const
    "Default specific heat capacity"
    annotation (Dialog(group="Configuration", enable=false));
  final parameter Real capHea_nominal(final unit="W")=sum(chaSta.capEqu)
    "Installed heating capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Real THeaWatSup_nominal(final unit="K", displayUnit="degC")=
    Buildings.Templates.Data.Defaults.THeaWatSupMed
    "Design HW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  final parameter Real THeaWatRet_nominal(final unit="K", displayUnit="degC")=
    Buildings.Templates.Data.Defaults.THeaWatRetMed
    "Design HW return temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VHeaWat_flow_nominal(final unit="m3/s")=
    capHea_nominal / (THeaWatSup_nominal - THeaWatRet_nominal) / cp_default / rho_default
    "Design primary HW volume flow rate"
    annotation(Dialog(group="Nominal condition"));
  final parameter Integer nSta = size(chaSta.staEqu, 1)
    "Number of stages"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratV_flow(
    table=[
      0,0;
      1,0;
      5,0.2;
      6,0.01;
        11,1; 12,1; 18,0], timeScale=1000)
    "Source signal for volume flow rate ratio"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Templates.Plants.Controls.StagingRotation.StageChangeCommand chaSta(
    plrSta=0.9,
    staEqu=[1,0,0; 0,0.5,0.5; 1,0.5,0.5; 0,1,1; 1,1,1],
    capEqu=1E3*{100,450,450},
    cp_default=cp_default,
    rho_default=rho_default)
    "Generate stage change command"
    annotation (Placement(transformation(extent={{-10,-12},{10,12}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet(final k=
        THeaWatSup_nominal) "HWST setpoint"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRet(final k=
        THeaWatRet_nominal) "HWRT"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Utilities.StageIndex idxSta(final nSta=nSta, dtRun=900) "Compute stage index"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Lea(k=true)
    "Lead equipment enable signal"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaSta[nSta](each k=true)
    "Stage available signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold y1UpHol(trueHoldDuration=1,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold y1DowHol(trueHoldDuration=1,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter V_flow(final k=
        VHeaWat_flow_nominal) "Scale by design flow"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
equation
  connect(TRet.y,chaSta. TRet)
    annotation (Line(points={{-68,0},{-60,0},{-60,-2},{-12,-2}},
                                               color={0,0,127}));
  connect(TSupSet.y,chaSta. TSupSet) annotation (Line(points={{-68,40},{-60,40},
          {-60,2},{-12,2}}, color={0,0,127}));
  connect(chaSta.y1Up, idxSta.u1Up)
    annotation (Line(points={{12,4},{20,4},{20,2},{38,2}}, color={255,0,255}));
  connect(chaSta.y1Dow, idxSta.u1Dow) annotation (Line(points={{12,-4},{20,-4},{
          20,-2},{38,-2}}, color={255,0,255}));
  connect(u1Lea.y, idxSta.u1Lea) annotation (Line(points={{-68,80},{30,80},{30,6},
          {38,6}}, color={255,0,255}));
  connect(u1AvaSta.y, idxSta.u1Ava) annotation (Line(points={{-68,-80},{30,-80},
          {30,-6},{38,-6}}, color={255,0,255}));
  connect(idxSta.y,chaSta. uSta) annotation (Line(points={{62,0},{80,0},{80,20},
          {-20,20},{-20,10},{-12,10}},
                                     color={255,127,0}));
  connect(chaSta.y1Up, y1UpHol.u) annotation (Line(points={{12,4},{20,4},{20,40},
          {38,40}}, color={255,0,255}));
  connect(chaSta.y1Dow, y1DowHol.u) annotation (Line(points={{12,-4},{20,-4},{20,
          -40},{38,-40}}, color={255,0,255}));
  connect(u1AvaSta.y, chaSta.u1AvaSta) annotation (Line(points={{-68,-80},{-20,-80},
          {-20,6},{-12,6}}, color={255,0,255}));
  connect(ratV_flow.y[1], V_flow.u)
    annotation (Line(points={{-68,-40},{-62,-40}}, color={0,0,127}));
  connect(V_flow.y, chaSta.V_flow) annotation (Line(points={{-38,-40},{-16,-40},
          {-16,-6},{-12,-6}}, color={0,0,127}));
  annotation (
      __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/StageChangeCommand.mos"
        "Simulate and plot"),
    experiment(
      StopTime=20000.0,
      Tolerance=1e-06),
  Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end StageChangeCommand;

within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model StageChangeCommand "Validation model for stage change logic"
  parameter Real cp_default(
    final unit="J/(kg.K)")=4184
    "Default specific heat capacity"
    annotation (Dialog(group="Configuration",
      enable=false));
  parameter Real rho_default(
    final unit="kg/m3")=996
    "Default specific heat capacity"
    annotation (Dialog(group="Configuration",
      enable=false));
  final parameter Real capHea_nominal(
    final unit="W")=sum(chaSta.capEqu)
    "Installed heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Real THeaWatSup_nominal(
    final unit="K",
    displayUnit="degC")=50 + 273.15
    "Design HW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  final parameter Real THeaWatRet_nominal(
    final unit="K",
    displayUnit="degC")=42 + 273.15
    "Design HW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real VHeaWat_flow_nominal(
    final unit="m3/s")=capHea_nominal /(THeaWatSup_nominal - THeaWatRet_nominal) /
    cp_default / rho_default
    "Design primary HW volume flow rate"
    annotation (Dialog(group="Nominal condition"));
  final parameter Integer nSta=size(chaSta.staEqu, 1)
    "Number of stages"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratV_flow(
    table=[
      0, 0;
      1, 0;
      5, 0.2;
      6, 0.01;
      11, 1;
      12, 1;
      18, 0],
    timeScale=1000)
    "Source signal for volume flow rate ratio"
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
  Buildings.Templates.Plants.Controls.StagingRotation.StageChangeCommand chaSta(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    have_pumSec=false,
    plrSta=0.9,
    staEqu=[1,0,0; 0,1/2,1/2; 1,1/2,1/2; 0,1,1; 1,1,1],
    capEqu=1E3*{100,450,450},
    cp_default=cp_default,
    rho_default=rho_default,
    dT=2.5) "Generate stage change command"
    annotation (Placement(transformation(extent={{-50,-12},{-30,12}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet(
    final k=THeaWatSup_nominal)
    "HWST setpoint"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRet(
    final k=THeaWatRet_nominal)
    "HWRT"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Utilities.StageIndex idxSta(
    final nSta=nSta, dtRun=900)
    "Compute stage index"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Lea(
    k=true)
    "Lead equipment enable signal"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaSta[nSta](
    each k=true)
    "Stage available signal"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHold      y1UpHol(duration=1)
    "Hold stage up command for plotting"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHold      y1DowHol(duration=1)
    "Hold stage down command for plotting"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter V_flow(
    final k=VHeaWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable enaEqu(
    final staEqu=chaSta.staEqu)
    "Enable equipment"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxEquLeaLag[2](
    final k={2, 3})
    "Indices of lead/lag equipment"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaEqu[3](
    each final k=true)
    "Equipment available signal"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Components.Controls.StatusEmulator staEqu[3](
    each riseTime=60)
    "Evaluate equipment status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Templates.Plants.Controls.StagingRotation.StageCompletion comSta(
    nin=3)
    "Check completion of stage change"
    annotation (Placement(transformation(extent={{-30,50},{-50,70}})));
equation
  connect(TRet.y, chaSta.TRet)
    annotation (Line(points={{-108,0},{-104,0},{-104,-6},{-52,-6}},color={0,0,127}));
  connect(TSupSet.y, chaSta.TSupSet)
    annotation (Line(points={{-108,40},{-100,40},{-100,0},{-52,0}},  color={0,0,127}));
  connect(chaSta.y1Up, idxSta.u1Up)
    annotation (Line(points={{-28,4},{-20,4},{-20,2},{-2,2}},color={255,0,255}));
  connect(chaSta.y1Dow, idxSta.u1Dow)
    annotation (Line(points={{-28,-4},{-20,-4},{-20,-2},{-2,-2}},color={255,0,255}));
  connect(u1Lea.y, idxSta.u1Lea)
    annotation (Line(points={{-108,80},{-10,80},{-10,6},{-2,6}},color={255,0,255}));
  connect(u1AvaSta.y, idxSta.u1AvaSta)
    annotation (Line(points={{-108,-80},{-10,-80},{-10,-6},{-2,-6}},color={255,0,255}));
  connect(idxSta.y, chaSta.uSta)
    annotation (Line(points={{22,0},{40,0},{40,20},{-56,20},{-56,10},{-52,10}},
      color={255,127,0}));
  connect(chaSta.y1Up, y1UpHol.u)
    annotation (Line(points={{-28,4},{-20,4},{-20,40},{-2,40}},color={255,0,255}));
  connect(chaSta.y1Dow, y1DowHol.u)
    annotation (Line(points={{-28,-4},{-20,-4},{-20,-40},{-2,-40}},color={255,0,255}));
  connect(u1AvaSta.y, chaSta.u1AvaSta)
    annotation (Line(points={{-108,-80},{-60,-80},{-60,6},{-52,6}},color={255,0,255}));
  connect(ratV_flow.y[1], V_flow.u)
    annotation (Line(points={{-108,-40},{-102,-40}},color={0,0,127}));
  connect(V_flow.y, chaSta.V_flow)
    annotation (Line(points={{-78,-40},{-56,-40},{-56,-8},{-52,-8}},color={0,0,127}));
  connect(idxSta.y, enaEqu.uSta)
    annotation (Line(points={{22,0},{58,0}},color={255,127,0}));
  connect(idxEquLeaLag.y, enaEqu.uIdxAltSor)
    annotation (Line(points={{-78,100},{54,100},{54,6},{58,6}},color={255,127,0}));
  connect(u1AvaEqu.y, enaEqu.u1Ava)
    annotation (Line(points={{-78,-100},{54,-100},{54,-6},{58,-6}},color={255,0,255}));
  connect(enaEqu.y1, staEqu.y1)
    annotation (Line(points={{82,0},{98,0}},color={255,0,255}));
  connect(comSta.y1, chaSta.u1StaPro)
    annotation (Line(points={{-52,54},{-58,54},{-58,4},{-52,4}},color={255,0,255}));
  connect(enaEqu.y1, comSta.u1)
    annotation (Line(points={{82,0},{90,0},{90,60},{-28,60},{-28,60}},color={255,0,255}));
  connect(staEqu.y1_actual, comSta.u1_actual)
    annotation (Line(points={{122,0},{130,0},{130,56},{-28,56}},color={255,0,255}));
  connect(idxSta.y, comSta.uSta)
    annotation (Line(points={{22,0},{40,0},{40,64},{-28,64}},color={255,127,0}));
  connect(TSupSet.y, chaSta.TPriSup) annotation (Line(points={{-108,40},{-100,
          40},{-100,-2},{-52,-2}}, color={0,0,127}));
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        extent={{-140,-120},{140,120}})),
    Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.StageChangeCommand\">
Buildings.Templates.Plants.Controls.StagingRotation.StageChangeCommand</a>
in a configuration with one small unit and two large equally sized 
units (component <code>avaStaOneTwo</code>).
In response to a varying flow rate, the variation of the
required capacity <code>chaSta.capReq.y</code> triggers stage change
events.
The block 
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.StageIndex\">
Buildings.Templates.Plants.Controls.Utilities.StageIndex</a>
is used to illustrate how these events translate into
a varying plant stage index <code>idxSta.y</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StageChangeCommand;

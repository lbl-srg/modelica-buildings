within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block StagingPump "Pump staging"

  parameter Integer nPum(
    final min=1,
    start=1)
    "Number of pumps"
    annotation(Evaluate=true);
  parameter Integer nChi(
    final min=1,
    start=1)
    "Number of chillers served by the pumps"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal
    "Design mass flow rate (each pump)"
    annotation(Dialog(group="Nominal condition"));


  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow(final unit="kg/s")
    "Mass flow rate as measured by the loop flow meter" annotation (Placement(
        transformation(extent={{-220,20},{-180,60}}), iconTransformation(extent
          ={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal[nChi](each final unit="1")
    "Chiller isolation valve commanded position"
    annotation (Placement(
        transformation(extent={{-220,-60},{-180,-20}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPum]
    "Start signal (VFD Run or motor starter contact)"
    annotation (Placement(
        transformation(extent={{180,-20},{220,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter ratFlo(k=1/(nPum*
        mPum_flow_nominal)) "Ratio of current flow rate to design value"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmdLead(t=5E-2, h=1E-2)
    "Command lead pump to start if any valve commanded open"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sum1(nin=nChi)
    "Sum up control signals"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addOff(p=0.03)
    "Add offset"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger numOpe
    "Number of pumps to be operating"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movAve(delta=600)
    "Moving average"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(final nout=
        nPum)        "Replicate"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cmdLag[nPum](t={i
        for i in 1:nPum})
    "Compute pump Start command from number of pumps to be commanded On"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter sca(k=nPum) "Scale"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(cmdLead.u, sum1.y)
    annotation (Line(points={{-122,-40},{-138,-40}}, color={0,0,127}));
  connect(yVal, sum1.u)
    annotation (Line(points={{-200,-40},{-162,-40}},   color={0,0,127}));
  connect(ratFlo.y, addOff.u)
    annotation (Line(points={{-98,40},{-82,40}}, color={0,0,127}));
  connect(m_flow, movAve.u) annotation (Line(points={{-200,40},{-182,40},{-182,40},
          {-162,40}}, color={0,0,127}));
  connect(movAve.y, ratFlo.u)
    annotation (Line(points={{-138,40},{-122,40}}, color={0,0,127}));
  connect(numOpe.y, rep.u)
    annotation (Line(points={{22,40},{38,40}}, color={255,127,0}));
  connect(rep.y, cmdLag.u)
    annotation (Line(points={{62,40},{78,40}}, color={255,127,0}));
  connect(cmdLead.y, y1[1]) annotation (Line(points={{-98,-40},{160,-40},{160,0},
          {200,0}}, color={255,0,255}));
  connect(cmdLag[2:nPum].y, y1[2:nPum]) annotation (Line(points={{102,40},{160,
          40},{160,0},{200,0}},
                            color={255,0,255}));
  connect(addOff.y, sca.u)
    annotation (Line(points={{-58,40},{-42,40}}, color={0,0,127}));
  connect(sca.y, numOpe.u)
    annotation (Line(points={{-18,40},{-2,40}}, color={0,0,127}));
  annotation (
  defaultComponentName="pum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}})));
end StagingPump;

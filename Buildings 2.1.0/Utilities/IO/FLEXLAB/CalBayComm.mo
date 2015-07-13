within Buildings.Utilities.IO.FLEXLAB;
model CalBayComm
  "Model calling a Python script to communicate with the CalBay adapter"
  extends Modelica.Icons.Example;
  extends Modelica.Icons.UnderConstruction;
  parameter Modelica.SIunits.Time samplePeriod = 30
    "Sample period for communication";

  Modelica.Blocks.Sources.CombiTimeTable setPoint(
    tableOnFile=false,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[ -1,12;
           119,6;
           239,8;
           359,9;
           479,10;
           599,12]) "Setpoint for lights"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Utilities.IO.Python27.Real_Real calBay(
    functionName="CalBayComm",
    nDblWri=1,
    nDblRea=2,
    moduleName="CalBayComm",
    final samplePeriod=samplePeriod) "Interface to CalBay communication"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Feedback feedback "Control error"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  lightingController controller(final samplePeriod=samplePeriod)
    "Controller for light level"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
block lightingController "Block for control law"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Modelica.SIunits.Time samplePeriod "Sample period of component";
    Modelica.Blocks.Math.Gain gain(k=10)
      annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));

    Modelica.Blocks.Nonlinear.Limiter limiter(uMax=100, uMin=1)
      "Output limiter to constrain control signal"
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold(
    final samplePeriod=samplePeriod) "Zero order hold for feedback"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
equation
  connect(limiter.y, y) annotation (Line(
      points={{61,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(add.y, limiter.u) annotation (Line(
        points={{11,4.44089e-16},{26,4.44089e-16},{26,0},{38,0}},
        color={0,0,127},
        smooth=Smooth.None));

  connect(limiter.y, zeroOrderHold.u) annotation (Line(
      points={{61,0},{70,0},{70,-40},{12,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zeroOrderHold.y, add.u2) annotation (Line(
      points={{-11,-40},{-30,-40},{-30,-6},{-12,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, add.u1) annotation (Line(
      points={{-47,0},{-30,0},{-30,6},{-12,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u, gain.u) annotation (Line(
      points={{-120,8.88178e-16},{-95,8.88178e-16},{-95,0},{-70,0}},
      color={0,0,127},
      smooth=Smooth.None));
end lightingController;
equation
  connect(setPoint.y[1], feedback.u1) annotation (Line(
      points={{-59,0},{-38,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(calBay.yR[1], feedback.u2) annotation (Line(
      points={{61,-0.5},{70,-0.5},{70,-20},{-30,-20},{-30,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controller.y, calBay.uR[1])
                               annotation (Line(
      points={{21,0},{38,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback.y, controller.u)
                             annotation (Line(
      points={{-21,0},{-2,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (            Documentation(info="<html>
            <p>
            This example demonstrates how a Python script and model of a controller
            can be used to control experiments in the FLEXLAB test cells. It uses
            an instance of
            <a href=\"modelica://Buildings.Utilities.IO.Python27.Real_Real\">
            Buildings.Utilities.IO.Python27.Real_Real</a> to communicate with the
            CalBay adapter. The Python script is located at
            <a href=\"file://Buildings/Resources/Python-Sources/CalBayComm.py\">
            Buildings/Resources/Python-Sources/CalBayComm.py</a>. The script must be
            edited before it will effectively communicate with the CalBay adapter.
            The necessary changes include:
            </p>
            <ul>
            <li>The script currently does not have valid login or password credentials.
            The credentials will have to be replaced before communication with the
            CalBay adapter will succeed.</li>
            <li>To avoid accidental manipulation of controls, the script currently does
            not include effective commands. The desired commands must be added to the
            program before it will have any effect.</li>
            </ul>
            <p>
            More details describing the necessary changes to the script are provided in
            the documentation of the script itself.
            </p>
            <p>
            <b>Note:</b>
            This model is marked as under construction because the
            application programming interface for data exchange with the CalBay adaptor
            of FLEXLAB has not yet been finalized.
            The model works, however, with the CalBay infrastructure as of October 2013.
            </p>
            </html>",
            revisions = "<html>
            <ul>
            <li>
            April 30, 2014, by Michael Wetter:<br/>
            Updated time table for MSL 3.2.1.
            </li>
            <li>
            Sep 9, 2013 by Peter Grant:<br/>
            First implementation.
            </li>
            </ul>
            </html>"));
end CalBayComm;

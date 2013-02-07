within Districts.Electrical.QuasiStationary.SinglePhase;
package Conversion "Package with models for AC/DC conversion"
  extends Modelica.Icons.Package;
  model ACACConverter "AC AC converter"
    // fixme: add example. Consider adding a constant loss therm for
    // parasitic losses
    import Modelica.ComplexMath.real;
    import Modelica.ComplexMath.imag;
    import Modelica.ComplexMath.conj;
    import Modelica.ComplexMath.'abs';
    import Modelica.ComplexMath.arg;

    parameter Real conversionFactor
      "Ratio of QS rms voltage on side 2 / QS rms voltage on side 1";
    parameter Real eta(min=0, max=1)
      "Converter efficiency, pLoss = (1-eta) * 'abs'(v2QS)";
    Modelica.SIunits.Power LossPower "Loss power";

    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pin1_pQS
      "Positive pin on side 1"
      annotation (Placement(transformation(extent={{-110,110},{-90,90}}),
          iconTransformation(extent={{-110,110},{-90,90}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin1_nQS
      "Negative pin on side 1"
      annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
          iconTransformation(extent={{-110,-110},{-90,-90}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pin2_pQS
      "Positive pin on side 2"
      annotation (Placement(transformation(extent={{90,110},{110,90}}),
          iconTransformation(extent={{90,110},{110,90}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin2_nQS
      "Negative pin on side 2"
      annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
          iconTransformation(extent={{90,-110},{110,-90}})));
  protected
    Modelica.SIunits.ComplexVoltage  v1QS= pin1_pQS.v - pin1_nQS.v
      "AC QS voltage";
    Modelica.SIunits.ComplexCurrent  i1QS= pin1_pQS.i "AC QS current";
    output Modelica.SIunits.Voltage v1QSabs='abs'(v1QS) "Abs(AC QS voltage)";
    output Modelica.SIunits.Current i1QSabs='abs'(i1QS) "Abs(AC QS current)";
    Modelica.SIunits.ComplexPower  s1QS= v1QS*conj(i1QS) "AC QS apparent power";
    Modelica.SIunits.ActivePower p1QS = real(s1QS) "AC QS active power";
    Modelica.SIunits.ReactivePower q1QS = imag(s1QS) "AC QS reactive power";

    Modelica.SIunits.ComplexVoltage  v2QS= pin2_pQS.v - pin2_nQS.v
      "AC QS voltage";
    Modelica.SIunits.ComplexCurrent  i2QS= pin2_pQS.i "AC QS current";
    output Modelica.SIunits.Voltage v2QSabs='abs'(v2QS) "Abs(AC QS voltage)";
    output Modelica.SIunits.Current i2QSabs='abs'(i2QS) "Abs(AC QS current)";
    Modelica.SIunits.ComplexPower  s2QS= v2QS*conj(i2QS) "AC QS apparent power";
    Modelica.SIunits.ActivePower p2QS = real(s2QS) "AC QS active power";
    Modelica.SIunits.ReactivePower q2QS = imag(s2QS) "AC QS reactive power";

  equation
  //QS balances
    Connections.branch(pin1_pQS.reference, pin1_nQS.reference);
    Connections.branch(pin2_pQS.reference, pin2_nQS.reference);
    pin1_pQS.reference.gamma = pin1_nQS.reference.gamma;
    pin2_pQS.reference.gamma = pin2_nQS.reference.gamma;
    pin1_pQS.i + pin1_nQS.i = Complex(0);
    pin2_pQS.i + pin2_nQS.i = Complex(0);

  //voltage relation
    'abs'(v2QS) = 'abs'(v1QS)*conversionFactor;
  //fixme: do we need to do anything for the phase or should we assume the phase remains the same?
  //power balance
    LossPower = (1-eta) * 'abs'(v2QS);
    p1QS + p2QS - LossPower = 0;
  //define reactive power
    q1QS = 0;
    q2QS = 0;
    annotation (Diagram(graphics), Icon(graphics={
          Line(
            points={{2,100},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-100}},
            color={0,0,255},
            smooth=Smooth.None),
          Text(
            extent={{40,40},{100,0}},
            lineColor={0,0,255},
            textString="QS"),
          Line(
            points={{-2,100},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},
                {-2,-100}},
            color={85,170,255},
            smooth=Smooth.None),
          Text(
            extent={{-100,40},{-40,0}},
            lineColor={85,170,255},
            textString="QS"),
          Text(
            extent={{-100,92},{100,60}},
            lineColor={0,0,255},
            textString="%name"),
          Text(
            extent={{-100,-60},{100,-92}},
            lineColor={0,0,255},
            textString="%conversionFactor"),
          Text(
            extent={{-100,-100},{100,-132}},
            lineColor={0,0,255},
            textString="%eta")}),
      Documentation(info="<html>
<p>
This is an AC AC converter, based on a power balance between both QS circuit sides.
The paramater <i>conversionFactor</i> defines the ratio between averaged the QS rms voltages.
The loss of the converter is proportional to the power transmitted at the second circuit side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the second circuit side.
Furthermore, reactive power on both QS side are set to 0.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 29, 2012, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"));
  end ACACConverter;

  model ACDCConverter "AC DC converter"
    // fixme: add example. Consider adding a constant loss therm for
    // parasitic losses
    import Modelica.ComplexMath.real;
    import Modelica.ComplexMath.imag;
    import Modelica.ComplexMath.conj;
    import Modelica.ComplexMath.'abs';
    import Modelica.ComplexMath.arg;

    parameter Real conversionFactor "Ratio of DC voltage / QS rms voltage";
    parameter Real eta(min=0, max=1)
      "Converter efficiency, pLoss = (1-eta) * pDC";
    Modelica.SIunits.Power LossPower "Loss power";

    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin pin_pQS
      "Positive pin on AC side"
      annotation (Placement(transformation(extent={{-110,110},{-90,90}}),
          iconTransformation(extent={{-110,110},{-90,90}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin_nQS
      "Negative pin on AC side"
      annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
          iconTransformation(extent={{-110,-110},{-90,-90}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_pDC
      "Positive pin on DC side"
      annotation (Placement(transformation(extent={{90,110},{110,90}}),
          iconTransformation(extent={{90,110},{110,90}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_nDC
      "Negative pin on DC side"
      annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
          iconTransformation(extent={{90,-110},{110,-90}})));
  protected
    Modelica.SIunits.ComplexVoltage  vQS= pin_pQS.v - pin_nQS.v "AC QS voltage";
    Modelica.SIunits.ComplexCurrent  iQS= pin_pQS.i "AC QS current";
    output Modelica.SIunits.Voltage vQSabs='abs'(vQS) "Abs(AC QS voltage)";
    output Modelica.SIunits.Current iQSabs='abs'(iQS) "Abs(AC QS current)";
    Modelica.SIunits.ComplexPower  sQS= vQS*conj(iQS) "AC QS apparent power";
    Modelica.SIunits.ActivePower pQS = real(sQS) "AC QS active power";
    Modelica.SIunits.ReactivePower qQS = imag(sQS) "AC QS reactive power";
    Modelica.SIunits.Voltage vDC = pin_pDC.v - pin_nDC.v "DC voltage";
    Modelica.SIunits.Current iDC = pin_pDC.i "DC current";
    Modelica.SIunits.Power pDC = vDC*iDC "DC power";
  equation
  //QS balances
    Connections.branch(pin_pQS.reference, pin_nQS.reference);
    pin_pQS.reference.gamma = pin_nQS.reference.gamma;
    pin_pQS.i + pin_nQS.i = Complex(0);
  //DC current balance
    pin_pDC.i + pin_nDC.i = 0;
  //voltage relation
    vDC = 'abs'(vQS)*conversionFactor;
  //power balance
    LossPower = (1-eta) * abs(pDC);
    pQS + pDC - LossPower = 0;
  //define reactive power
    qQS = 0;
    annotation (Diagram(graphics), Icon(graphics={
          Line(
            points={{2,100},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-100}},
            color={0,0,255},
            smooth=Smooth.None),
          Text(
            extent={{40,40},{100,0}},
            lineColor={0,0,255},
            textString="DC"),
          Line(
            points={{-2,100},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},
                {-2,-100}},
            color={85,170,255},
            smooth=Smooth.None),
          Text(
            extent={{-100,40},{-40,0}},
            lineColor={85,170,255},
            textString="QS"),
          Text(
            extent={{-100,92},{100,60}},
            lineColor={0,0,255},
            textString="%name"),
          Text(
            extent={{-100,-60},{100,-92}},
            lineColor={0,0,255},
            textString="%conversionFactor"),
          Text(
            extent={{-100,-100},{100,-132}},
            lineColor={0,0,255},
            textString="%eta")}),
      Documentation(info="<html>
<p>
This is an AC DC converter, based on a power balance between QS circuit and DC side.
The paramater <i>conversionFactor</i> defines the ratio between averaged DC voltage and QS rms voltage.
The loss of the converter is proportional to the power transmitted at the DC side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC</sub>|</i>,
where <i>|P<sub>DC</sub>|</i> is the power transmitted on the DC side.
Furthermore, reactive power at the QS side is set to 0.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealACDCConverter</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 4, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end ACDCConverter;

  package Examples "Package with examples"
    extends Modelica.Icons.ExamplesPackage;

    model ACACConverter "Test model AC to AC converter"
      import Districts;
      extends Modelica.Icons.Example;

      Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro
        annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
    //protected
      //fixme. I need to specify a value for the real or imaginary part of resitor.i
    public
      Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor res(
        alpha_ref=100,
        R_ref=1,
        i(re(start=1), im(start=0)),
        T_ref=293.15)   annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={50,14})));
      Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro1
        annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
      Districts.Electrical.QuasiStationary.SinglePhase.Conversion.ACACConverter
        conACAC(conversionFactor=0.5, eta=0.9)
        annotation (Placement(transformation(extent={{-10,0},{10,20}})));
      Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource sou(
        f=60,
        V=120,
        phi=0)                annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-44,10})));
    equation
      connect(res.pin_n, gro1.pin)         annotation (Line(
          points={{50,4},{50,-40},{10,-40}},
          color={85,170,255},
          smooth=Smooth.None));
      connect(conACAC.pin2_pQS, res.pin_p)            annotation (Line(
          points={{10,20},{10,60},{50,60},{50,24}},
          color={85,170,255},
          smooth=Smooth.None));
      connect(gro1.pin, conACAC.pin2_nQS)          annotation (Line(
          points={{10,-40},{10,0}},
          color={85,170,255},
          smooth=Smooth.None));
      connect(sou.pin_p, conACAC.pin1_pQS)                         annotation (
          Line(
          points={{-44,20},{-44,60},{-10,60},{-10,20}},
          color={85,170,255},
          smooth=Smooth.None));
      connect(sou.pin_n, gro.pin)                      annotation (Line(
          points={{-44,0},{-44,-40},{-10,-40}},
          color={85,170,255},
          smooth=Smooth.None));
      connect(gro.pin, conACAC.pin1_nQS)          annotation (Line(
          points={{-10,-40},{-10,0}},
          color={85,170,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=3600, Tolerance=1e-05),
        __Dymola_experimentSetupOutput,
        Documentation(info="<html>
<p>
This model illustrates the use of a model that converts AC voltage to AC voltage.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2013, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"),
        Commands(file=
              "Resources/Scripts/Dymola/Electrical/QuasiStationary/SinglePhase/Conversion/Examples/ACACConverter.mos"
            "Simulate and plot"));
    end ACACConverter;

    model ACDCConverter "Test model AC to DC converter"
      import Districts;
      extends Modelica.Icons.Example;

      Modelica.Electrical.Analog.Basic.Resistor res(R=1)      annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={60,10})));
      Modelica.Electrical.Analog.Basic.Ground groDC
      annotation (Placement(transformation(extent={{0,-60},{20,-40}},    rotation=0)));
      Districts.Electrical.QuasiStationary.SinglePhase.Conversion.ACDCConverter
        conACDC(eta=0.9, conversionFactor=0.5)
        annotation (Placement(transformation(extent={{-10,0},{10,20}})));
      Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground groAC
        annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
    protected
      Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource sou(
        final f=60,
        final V=120,
        final phi(displayUnit="rad") = 0) "Voltage source"
         annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-60,10})));
    equation
      connect(res.p, conACDC.pin_pDC)            annotation (Line(
          points={{60,20},{60,60},{10,60},{10,20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(res.n, conACDC.pin_nDC)            annotation (Line(
          points={{60,0},{60,-40},{10,-40},{10,0}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(groDC.p, conACDC.pin_nDC)         annotation (Line(
          points={{10,-40},{10,0}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(groAC.pin, conACDC.pin_nQS)        annotation (Line(
          points={{-10,-40},{-10,0}},
          color={85,170,255},
          smooth=Smooth.None));
      connect(sou.pin_p, conACDC.pin_pQS)       annotation (Line(
          points={{-60,20},{-60,60},{-10,60},{-10,20}},
          color={85,170,255},
          smooth=Smooth.None));
      connect(sou.pin_n, groAC.pin)  annotation (Line(
          points={{-60,0},{-60,-40},{-10,-40}},
          color={85,170,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=3600, Tolerance=1e-05),
        __Dymola_experimentSetupOutput,
        Documentation(info="<html>
<p>
This model illustrates the use of a model that converts AC voltage to DC voltage.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2013, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"),
        Commands(file=
              "Resources/Scripts/Dymola/Electrical/QuasiStationary/SinglePhase/Conversion/Examples/ACDCConverter.mos"
            "Simulate and plot"));
    end ACDCConverter;

  end Examples;
end Conversion;

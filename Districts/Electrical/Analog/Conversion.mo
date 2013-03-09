within Districts.Electrical.Analog;
package Conversion "Package with models for DC/DC conversion"
  extends Modelica.Icons.Package;

  model DCDCConverter "DC DC converter"
    // fixme: add example. Consider adding a constant loss therm for

    parameter Real conversionFactor
      "Ratio of DC voltage on side 2 / DC voltage on side 1";
    parameter Real eta(min=0, max=1)
      "Converter efficiency, pLoss = (1-eta) * pDC2";
    Modelica.SIunits.Power LossPower "Loss power";

    Modelica.Electrical.Analog.Interfaces.PositivePin pin1_pDC
      "Positive pin on side 1"
      annotation (Placement(transformation(extent={{-110,110},{-90,90}}),
          iconTransformation(extent={{-110,110},{-90,90}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin1_nDC
      "Negative pin on side 1"
      annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
          iconTransformation(extent={{-110,-110},{-90,-90}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin2_pDC
      "Positive pin on side 2"
      annotation (Placement(transformation(extent={{90,110},{110,90}}),
          iconTransformation(extent={{90,110},{110,90}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin2_nDC
      "Negative pin on side 2"
      annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
          iconTransformation(extent={{90,-110},{110,-90}})));
  protected
    Modelica.SIunits.Voltage vDC1= pin1_pDC.v - pin1_nDC.v "DC voltage";
    Modelica.SIunits.Current iDC1 = pin1_pDC.i "DC current";
    Modelica.SIunits.Power pDC1 = vDC1*iDC1 "DC power";
    Modelica.SIunits.Voltage vDC2 = pin2_pDC.v - pin2_nDC.v "DC voltage";
    Modelica.SIunits.Current iDC2 = pin2_pDC.i "DC current";
    Modelica.SIunits.Power pDC2 = vDC2*iDC2 "DC power";
  equation

   //DC current balance
    pin1_pDC.i + pin1_nDC.i = 0;
  //DC current balance
    pin2_pDC.i + pin2_nDC.i = 0;
  //voltage relation
    vDC2 = vDC1*conversionFactor;
  //power balance
    LossPower = (1-eta) * abs(pDC2);
    pDC1 + pDC2 - LossPower = 0;

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
            textString="DC"),
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
This is an DC DC converter, based on a power balance between DC and DC side.
The paramater <i>conversionFactor</i> defines the ratio between the two averaged DC voltages
The loss of the converter is proportional to the power transmitted to the second DC side.
The parameter <code>eps</code> is the efficiency of the transfer.
The loss is computed as
<i>P<sub>loss</sub> = (1-&eta;) |P<sub>DC2</sub>|</i>,
where <i>|P<sub>DC2</sub>|</i> is the power transmitted on the second DC side.
</p>
<h4>Note:</h4>
<p>
This model is derived from 
<a href=\"modelica://Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealDCDCConverter\">
Modelica.Electrical.QuasiStationary.SinglePhase.Utilities.IdealDCDCConverter</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 28, 2012, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"));
  end DCDCConverter;

  package Examples "Package with examples"
    extends Modelica.Icons.ExamplesPackage;

    model DCDCConverter "Test model DC to DC converter"
      import Districts;
      extends Modelica.Icons.Example;

      Districts.Electrical.Analog.Conversion.DCDCConverter conDCDC(eta=0.9,
          conversionFactor=0.5)
        annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
      Modelica.Electrical.Analog.Sources.ConstantVoltage sou(V=120)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={-60,10})));
      Modelica.Electrical.Analog.Basic.Resistor res(R=1)      annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={60,10})));
      Modelica.Electrical.Analog.Basic.Ground gro1
      annotation (Placement(transformation(extent={{2,-68},{18,-52}},    rotation=0)));
      Modelica.Electrical.Analog.Basic.Ground gro
      annotation (Placement(transformation(extent={{-18,-68},{-2,-52}},  rotation=0)));
    equation
      connect(sou.p, conDCDC.pin1_pDC)                   annotation (Line(
          points={{-60,20},{-60,60},{-10,60},{-10,16}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(sou.n, conDCDC.pin1_nDC)                   annotation (Line(
          points={{-60,0},{-60,-40},{-10,-40},{-10,-4}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(conDCDC.pin2_pDC, res.p)            annotation (Line(
          points={{10,16},{10,60},{60,60},{60,20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(conDCDC.pin2_nDC, res.n)            annotation (Line(
          points={{10,-4},{10,-40},{60,-40},{60,0}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(gro1.p, conDCDC.pin2_nDC)          annotation (Line(
          points={{10,-52},{10,-4}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(gro.p, conDCDC.pin1_nDC)          annotation (Line(
          points={{-10,-52},{-10,-4}},
          color={0,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), experiment(StopTime=3600, Tolerance=1e-05),
        __Dymola_experimentSetupOutput,
        Documentation(info="<html>
<p>
This model illustrates the use of a model that converts DC voltage to DC voltage.
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
              "Resources/Scripts/Dymola/Electrical/Analog/Conversion/Examples/DCDCConverter.mos"
            "Simulate and plot"));
    end DCDCConverter;
  end Examples;
end Conversion;

within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion;
package Examples "Package with example models"
  extends Modelica.Icons.ExamplesPackage;
  annotation (Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
  model Converter "Test for the AC/AC converter model"
    extends BaseClasses.TransformerExample(
    V_primary = 480,
    V_secondary = 240,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
                                                                     probe_2,
    redeclare
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACConverter
        tra(conversionFactor=0.5,eta=0.9));
    annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example model tests the 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACConverter\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACConverter</a> model.
</p>
</html>"),
  experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/Converter.mos"
          "Simulate and plot"));
  end Converter;

  model Transformer "Test for the AC/AC transformer model"
    extends BaseClasses.TransformerExample(
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
                                                                     probe_2,
    redeclare
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformer
        tra(
        VHigh=V_primary,
        VLow=V_secondary,
        XoverR=6,
        Zperc=sqrt(0.01^2 + 0.06^2),
        VABase=6000000));
    annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example model tests the 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformer\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformer</a> model.
</p>
</html>"),
  experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/Transformer.mos"
          "Simulate and plot"));
  end Transformer;

  model TransformerFull "Test for the AC/AC transformer full model"
    extends BaseClasses.TransformerExample(
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
                                                                     probe_2,
    redeclare
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerFull
        tra(
        VHigh=V_primary,
        VLow=V_secondary,
        VABase=6000000,
        f=60,
        R1=0.005,
        L1=0.005*6,
        R2=0.005,
        L2=0.005*6,
        magEffects=true,
        Rm=10,
        Lm=10), load(initMode=Buildings.Electrical.Types.InitMode.linearized));
    annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example model tests the 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerFull\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerFull</a> model.
</p>
</html>"),
  experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerFull.mos"
          "Simulate and plot"));
  end TransformerFull;

  model TransformerDD
    "Test for the AC/AC transformer model with Delta-Delta configuration"
    extends BaseClasses.TransformerExample(
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta
                                                                       probe_2,
    redeclare
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerDD
        tra(
        VHigh=V_primary,
        VLow=V_secondary,
        XoverR=6,
        Zperc=sqrt(0.01^2 + 0.06^2),
        VABase=6000000));
    annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example model tests the 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerDD\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerDD</a> model.
</p>
<h4>Note:</h4>
<p>
When the secondary side of the transformer is in Delta (D) configuration
measuring the voltage with a Wye (Y) is not possible because the voltage vectors
in the connector do not have a neutral reference anymore.
</p>
</html>"),
  experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerDD.mos"
          "Simulate and plot"));
  end TransformerDD;

  model TransformerStepDownYD
    "Test for the AC/AC transformer model with Wye-Delta configuration (step-down voltage)"
    extends BaseClasses.TransformerExample(
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta
                                                                       probe_2,
    redeclare
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownYD
        tra(
        VHigh=V_primary,
        VLow=V_secondary,
        XoverR=6,
        Zperc=sqrt(0.01^2 + 0.06^2),
        VABase=6000000));
    annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example model tests the 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownYD\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownYD</a> model.
</p>
<h4>Note:</h4>
<p>
When the secondary side of the transformer is in Delta (D) configuration
measuring the voltage with a Wye (Y) is not possible because the voltage vectors
in the connector do not have a neutral reference anymore.
</p>
</html>"),
  experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerStepDownYD.mos"
          "Simulate and plot"));
  end TransformerStepDownYD;

  model TransformerStepUpYD
    "Test for the AC/AC transformer model with Wye-Delta configuration (step-up voltage)"
    extends BaseClasses.TransformerExample(
    V_primary = 4160,
    V_secondary = 12470,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta
                                                                       probe_2,
    redeclare
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepUpYD
        tra(
        VHigh=V_primary,
        VLow=V_secondary,
        XoverR=6,
        Zperc=sqrt(0.01^2 + 0.06^2),
        VABase=6000000));
    annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example model tests the 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepUpYD\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepUpYD</a> model.
</p>
<h4>Note:</h4>
<p>
When the secondary side of the transformer is in Delta (D) configuration
measuring the voltage with a Wye (Y) is not possible because the voltage vectors
in the connector do not have a neutral reference anymore.
</p>
</html>"),
  experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerStepUpYD.mos"
          "Simulate and plot"));
  end TransformerStepUpYD;

  model TransformerStepDownDY
    "Test for the AC/AC transformer model with Delta-Wye configuration (step-down voltage)"
    extends BaseClasses.TransformerExample(
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
                                                                     probe_2,
    redeclare
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownDY
        tra(
        VHigh=V_primary,
        VLow=V_secondary,
        XoverR=6,
        Zperc=sqrt(0.01^2 + 0.06^2),
        VABase=6000000));
    annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example model tests the 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownDY\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepDownDY</a> model.
</p>
</html>"),
  experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerStepDownDY.mos"
          "Simulate and plot"));
  end TransformerStepDownDY;

  model TransformerStepUpDY
    "Test for the AC/AC transformer model with Delta-Wye configuration (step-up voltage)"
    extends BaseClasses.TransformerExample(
    V_primary = 4160,
    V_secondary = 12470,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
                                                                     probe_2,
    redeclare
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepUpDY
        tra(
        VHigh=V_primary,
        VLow=V_secondary,
        XoverR=6,
        Zperc=sqrt(0.01^2 + 0.06^2),
        VABase=6000000));
    annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example model tests the 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepUpDY\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerStepUpDY</a> model.
</p>
</html>"),
  experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file=
   "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Conversion/Examples/TransformerStepUpDY.mos"
          "Simulate and plot"));
  end TransformerStepUpDY;

  package BaseClasses
    "This package contains base classes inherited by the examples"
    extends Modelica.Icons.BasesPackage;
    annotation (Documentation(info="<html>
<p>
This package contains base classes used by the examples that are part of the package
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
    model TransformerExample
      "This example represents the basic test for a transformer model"
      extends Modelica.Icons.Example;
      parameter Modelica.SIunits.Voltage V_primary = 12470
        "RMS Voltage on the primary side of the trasformer";
      parameter Modelica.SIunits.Voltage V_secondary = 4160
        "RMS Voltage on the secondary side of the trasformer";
      Sources.FixedVoltage sou(
        f=60,
        V=V_primary) "Voltage source"
        annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
      replaceable
        Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverter
        tra "Transformer model"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Loads.Resistive load(
        loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
        P_nominal=-1800e3,
        V_nominal=V_secondary) "Load model"
        annotation (Placement(transformation(extent={{50,-10},{70,10}})));
      Sensors.ProbeWye probe_Y_1(perUnit=false, V_nominal = V_primary)
        "Probe that measures the voltage in Y configuration, primary side"
        annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
      Sensors.ProbeDelta probe_D_1(perUnit=false, V_nominal = V_primary)
        "Probe that measures the voltage in D configuration, primary side"
        annotation (Placement(transformation(extent={{-40,-30},{-20,-50}})));
      replaceable Sensors.BaseClasses.GeneralizedProbe probe_2 constrainedby
        Sensors.BaseClasses.GeneralizedProbe(perUnit=false,
        V_nominal=V_secondary)
        "Probe that measures the voltage at the secondary side"
        annotation (Placement(transformation(extent={{20,30},{40,50}})));

    equation
      connect(sou.terminal, tra.terminal_n) annotation (Line(
          points={{-50,0},{-10,0}},
          color={0,120,120},
          smooth=Smooth.None));
      connect(probe_Y_1.term, tra.terminal_n) annotation (Line(
          points={{-30,31},{-30,0},{-10,0}},
          color={0,120,120},
          smooth=Smooth.None));
      connect(probe_D_1.term, tra.terminal_n) annotation (Line(
          points={{-30,-31},{-30,0},{-10,0}},
          color={0,120,120},
          smooth=Smooth.None));
      connect(tra.terminal_p, probe_2.term) annotation (Line(
          points={{10,0},{30,0},{30,31}},
          color={0,120,120},
          smooth=Smooth.None));
      connect(tra.terminal_p, load.terminal) annotation (Line(
          points={{10,0},{50,0}},
          color={0,120,120},
          smooth=Smooth.None));
      annotation (Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",     info="<html>
<p>
This model is the base classes used by the examples that are part of the package
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.Examples</a>.
</p>
<p>
The model has a voltage source, a transformer and a load. The transformer
model is replaceable so the different types of transformers can be easily tested.
</p>
</html>"),     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {100,100}}), graphics));
    end TransformerExample;
  end BaseClasses;
end Examples;

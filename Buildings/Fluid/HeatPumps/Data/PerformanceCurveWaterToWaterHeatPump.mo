within Buildings.Fluid.HeatPumps.Data;
package PerformanceCurveWaterToWaterHeatPump

 extends Modelica.Icons.MaterialPropertiesPackage;
  record Generic_DOE2 "Generic data for Water Source HeatPump"

   extends Buildings.Fluid.HeatPumps.Data.BaseClasses.WaterSourceHeatPump_DOE2(
        final nCapFunT=6,
        final nEIRFunT=6,
        final nEIRFunPLR=3);

   annotation (
   defaultComponentName="per",
      defaultComponentPrefixes="parameter",
      Documentation(info=
                   "<html>
<p>This record is used as a template for performance data
for the HeatPump model
<a href=\"Buildings.Fluid.HeatPumps.WSHP\">
Buildings.Fluid.HeatPumps.WSHP</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 19, 2014 by Michael Wetter:<br/>
Added <code>defaultComponentName</code> and <code>defaultComponentPrefixes</code>.
</li><li>
September 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  end Generic_DOE2;

  model Generic_equationFit "Generic data for TRANE-PRC022E HeatPump"

  extends Modelica.Icons.Function;

  //  parameter Modelica.SIunits.Temperature TConLvg=cataloge_data.TConLvg;
  //
  //  parameter Modelica.SIunits.Temperature TEvaEnt=cataloge_data.TEvaEnt;
  //
  //  parameter Modelica.SIunits.VolumeFlowRate VCon=cataloge_data.VCon;
  //
  //  parameter Modelica.SIunits.VolumeFlowRate VEva=cataloge_data.VEva;
  //
  //  parameter Modelica.SIunits.VolumeFlowRate VCon_Ref=cataloge_data.VCon_Ref;

   parameter Real var1[36,1]=cataloge_data1.var1;
    parameter Real var2[36,1]=cataloge_data1.var2;
     parameter Real var3[36,1]=cataloge_data1.var3;
      parameter Real var4[36,1]=cataloge_data1.var4;
       parameter Real var5[36,1]=cataloge_data1.var5;
        parameter Real var6[36,1]=cataloge_data1.var6;
         parameter Real unity[36,1]=cataloge_data1.unity;

    parameter Buildings.Fluid.HeatPumps.Data.PerformanceCurveWaterToWaterHeatPump.cataloge_data cataloge_data1(
      TConLvg=[288.7; 288.7; 288.7; 288.7; 288.7; 288.7; 288.7; 288.7; 288.7; 288.7; 288.7; 288.7; 288.7;
          288.7; 288.7; 288.7; 288.7; 288.7; 310.9; 310.9; 310.9; 310.9; 310.9; 310.9; 310.9; 310.9;
          310.9; 316.5; 316.5; 316.5; 316.5; 316.5; 316.5; 316.5; 316.5; 316.5],
      TEvaEnt=[280.4; 280.4; 280.4; 285.9; 285.9; 285.9; 280.4; 280.4; 280.4; 280.4; 280.4; 280.4; 285.9;
          285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9;
          285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9; 285.9],
      VCon=[0.00189; 0.00189; 0.00189; 0.00189; 0.00189; 0.00189; 0.00315; 0.00315; 0.00315; 0.00442;
          0.00442; 0.00442; 0.00315; 0.00315; 0.00315; 0.00442; 0.00442; 0.00442; 0.00189; 0.00189;
          0.00189; 0.00315; 0.00315; 0.00315; 0.00442; 0.00442; 0.00442; 0.00189; 0.00189; 0.00189;
          0.00315; 0.00315; 0.00315; 0.00442; 0.00442; 0.00442],
      QCon=[59914; 64264; 66149; 68411; 73196; 75516; 60407; 64612; 66671; 60552; 64786; 66816; 68962;
          73776; 76125; 69136; 73950; 76299; 63307; 67744; 69890; 63829; 68266; 70412; 63974; 68440;
          70615; 62031; 66352; 68469; 62524; 66874; 68991; 62669; 67048; 69165],
      VEva=[0.001892700296586; 0.00315450049431; 0.004416300692034; 0.001892700296586; 0.00315450049431;
          0.004416300692034; 0.001892700296586; 0.00315450049431; 0.004416300692034; 0.001892700296586;
          0.00315450049431; 0.004416300692034; 0.001892700296586; 0.00315450049431; 0.004416300692034;
          0.001892700296586; 0.00315450049431; 0.004416300692034; 0.001892700296586; 0.00315450049431;
          0.004416300692034; 0.001892700296586; 0.00315450049431; 0.004416300692034; 0.001892700296586;
          0.00315450049431; 0.004416300692034; 0.001892700296586; 0.00315450049431; 0.004416300692034;
          0.001892700296586; 0.00315450049431; 0.004416300692034; 0.001892700296586; 0.00315450049431;
          0.004416300692034],
      QEva=[49155; 53331; 55361; 57304; 62089; 64380; 50083; 54317; 56347; 50373; 54607; 56637; 58319;
          63133; 65482; 58667; 63452; 65801; 45617; 50025; 52171; 46893; 51359; 53505; 47270; 51736;
          53882; 42108; 46458; 48517; 43471; 47850; 49938; 43877; 48256; 50373],
      P=[10890; 10900; 10900; 11230; 11240; 11250; 10420; 10420; 10430; 10270; 10280; 10290; 10740;
          10750; 10760; 10590; 10600; 10610; 17870; 17880; 17900; 17100; 17110; 17120; 16860; 16870;
          16880; 20110; 20120; 20130; 19230; 19240; 19260; 18970; 18980; 18990],
      var1=[1.05; 1.05; 1.05; 1.05; 1.05; 1.05; 1.04; 1.04; 1.04; 1.03; 1.03; 1.03; 1.04; 1.04; 1.04;
          1.03; 1.03; 1.03; 1.13; 1.13; 1.13; 1.12; 1.12; 1.12; 1.11; 1.11; 1.11; 1.15; 1.15; 1.15;
          1.13; 1.14; 1.14; 1.13; 1.13; 1.13],
      var2=[0.99; 0.99; 0.99; 1.01; 1.01; 1.01; 0.99; 0.99; 0.99; 0.99; 0.99; 0.99; 1.01; 1.01; 1.01;
          1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01; 1.01;
          1.01; 1.01; 1.01; 1.01; 1.01; 1.01],
      var3=[1; 1; 1; 1; 1; 1; 1.67; 1.67; 1.67; 2.33; 2.33; 2.33; 1.67; 1.67; 1.67; 2.33; 2.33; 2.33;
          1; 1; 1; 1.67; 1.67; 1.67; 2.33; 2.33; 2.33; 1; 1; 1; 1.67; 1.67; 1.67; 2.33; 2.33; 2.33],
      var4=[1; 1.67; 2.33; 1; 1.67; 2.33; 1; 1.67; 2.33; 1; 1.67; 2.33; 1; 1.67; 2.33; 1; 1.67; 2.33;
          1; 1.67; 2.33; 1; 1.67; 2.33; 1; 1.67; 2.33; 1; 1.67; 2.33; 1; 1.67; 2.33; 1; 1.67; 2.33],
      var5=[0.79; 0.84; 0.87; 0.9; 0.96; 0.99; 0.79; 0.85; 0.88; 0.79; 0.85; 0.88; 0.91; 0.97; 1; 0.91;
          0.97; 1; 0.83; 0.89; 0.92; 0.84; 0.9; 0.92; 0.84; 0.9; 0.93; 0.81; 0.87; 0.9; 0.82; 0.88;
          0.91; 0.82; 0.88; 0.91],
      var6=[0.59; 0.59; 0.59; 0.6; 0.6; 0.61; 0.56; 0.56; 0.56; 0.55; 0.55; 0.55; 0.58; 0.58; 0.58;
          0.57; 0.57; 0.57; 0.96; 0.96; 0.96; 0.92; 0.92; 0.92; 0.91; 0.91; 0.91; 1.08; 1.08; 1.08;
          1.03; 1.04; 1.04; 1.02; 1.02; 1.02],
      unity=[1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;
          1; 1; 1; 1; 1; 1; 1],
      VCon_Ref=30/15850,
      VEva_Ref=30/15850,
      TRef=283.15,
      PRef=17000,
      QRef=70000);

  // Refrence values

  function solve

  input  Real A[36,5]= [unity,var1,var2,var3,var4];
  input  Real b[36,1]= [var5];
  output Real x[5,1];

    protected
    Integer info;

  algorithm

  x := Modelica.Math.Matrices.solve(A,b);
  //(x,info) := LAPACK.dgesv_vec(A, b);

   assert(info == 0, "Solving a linear system of equations with function
\"Matrices.solve\" is not possible, because the system has either
no or infinitely many solutions (A is singular).");
    annotation (Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Matrices.<b>solve</b>(A,b);
</pre></blockquote>
<h4>Description</h4>
<p>
This function call returns the
solution <b>x</b> of the linear system of equations
</p>
<blockquote>
<p>
<b>A</b>*<b>x</b> = <b>b</b>
</p>
</blockquote>
<p>
If a unique solution <b>x</b> does not exist (since <b>A</b> is singular),
an assertion is triggered. If this is not desired, use instead
<a href=\"modelica://Modelica.Math.Matrices.leastSquares\">Matrices.leastSquares</a>
and inquire the singularity of the solution with the return argument rank
(a unique solution is computed if rank = size(A,1)).
</p>

<p>
Note, the solution is computed with the LAPACK function \"dgesv\",
i.e., by Gaussian elimination with partial pivoting.
</p>
<h4>Example</h4>
<blockquote><pre>
  Real A[3,3] = [1,2,3;
                 3,4,5;
                 2,1,4];
  Real b[3] = {10,22,12};
  Real x[3];
<b>algorithm</b>
  x := Matrices.solve(A,b);  // x = {3,2,1}
</pre></blockquote>
<h4>See also</h4>
<a href=\"modelica://Modelica.Math.Matrices.LU\">Matrices.LU</a>,
<a href=\"modelica://Modelica.Math.Matrices.LU_solve\">Matrices.LU_solve</a>,
<a href=\"modelica://Modelica.Math.Matrices.leastSquares\">Matrices.leastSquares</a>.
</html>"));
  end solve;
  /*


equation 
 [var1] = [TConLvg]/[TRef];



/*
 var2 = (TEvaEnt/TRef);
 var3 = (VCon/VCon_Ref);
 var4 = (VEva/VEva_Ref);
 var5 = (QCon /QRef);
 var6 = (P /PRef);

*/

      annotation (Placement(transformation(extent={{-62,8},{-42,28}})),
              Placement(transformation(extent={{-58,12},{-38,32}})),
   defaultComponentName="cataloge perfromance data",
      defaultComponentPrefixes="parameter",
      Documentation(info=
                   "<html>
<p>This  is used as a template for performance data
for the HeatPump model
<a href=\"Buildings.Fluid.HeatPumps.WSHP\">
Buildings.Fluid.HeatPumps.WSHP</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 19, 2014 by Michael Wetter:<br/>
Added <code>defaultComponentName</code> and <code>defaultComponentPrefixes</code>.
</li><li>
September 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic_equationFit;

  record cataloge_data "Generic data for TRANE-PRC022E HeatPump"

   extends Modelica.Icons.Record;

   parameter Modelica.SIunits.Temperature TConLvg[36,1];

   parameter Modelica.SIunits.Temperature TEvaEnt[36,1];

   parameter Modelica.SIunits.VolumeFlowRate VCon[36,1];

   parameter Modelica.SIunits.VolumeFlowRate VEva[36,1];

   parameter Modelica.SIunits.VolumeFlowRate VCon_Ref
    annotation (Dialog(group="Nominal condition"));

   parameter Modelica.SIunits.VolumeFlowRate VEva_Ref
    annotation (Dialog(group="Nominal condition"));

   parameter Modelica.SIunits.Temperature TRef
    annotation (Dialog(group="Nominal condition"));
   parameter Modelica.SIunits.Power PRef
    annotation (Dialog(group="Nominal condition"));
   parameter Modelica.SIunits.HeatFlowRate QRef
    annotation (Dialog(group="Nominal condition"));

   parameter Modelica.SIunits.HeatFlowRate QCon[36,1];

   parameter Modelica.SIunits.HeatFlowRate QEva[36,1];

   parameter Modelica.SIunits.Power P[36,1];

   parameter Real var1[36,1]        "Number of coefficients for variable1 TConEnt/TRef"
  annotation (Dialog(group="Cataloge Performance data"));
   parameter Real var2[36,1]              "Number of coefficients for variable2 TEvaLvg/TRef"
  annotation (Dialog(group="Cataloge Performance data"));
   parameter Real var3[36,1] "Number of coefficients for variable3 VCon/VEvaRef"
  annotation (Dialog(group="Cataloge Performance data"));
   parameter Real var4[36,1]              "Number of coefficients for variable4 VEva/VEvaRef"
  annotation (Dialog(group="Cataloge Performance data"));
   parameter Real var5[36,1]              "Number of coefficients for variable5 QCon/QRef"
  annotation (Dialog(group="Cataloge Performance data"));
   parameter Real var6[36,1]              "Number of coefficients for variable6 P/PRef"
  annotation (Dialog(group="Cataloge Performance data"));

  protected
   parameter Real unity[36,1]=[1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1;
        1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];

   /*
 i want to correlate number of operating ponints directly to the matrix size of all variables, so when i add more data i dont have to resize all matrix
 
 parameter Integer n_operating_points [36];
*/

   annotation (
   defaultComponentName="cataloge perfromance data",
      defaultComponentPrefixes="parameter",
      Documentation(info=
                   "<html>
<p>This record is used as a template for performance data
for the HeatPump model
<a href=\"Buildings.Fluid.HeatPumps.WSHP\">
Buildings.Fluid.HeatPumps.WSHP</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 19, 2014 by Michael Wetter:<br/>
Added <code>defaultComponentName</code> and <code>defaultComponentPrefixes</code>.
</li><li>
September 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end cataloge_data;

  model equationFitModel

   extends
      Buildings.Fluid.HeatPumps.Data.PerformanceCurveWaterToWaterHeatPump.Generic_equationFit;

  equation

   var1 = (TConLvg/TRef);
   var2 = (TEvaEnt/TRef);
   var3 = (VCon/VCon_Ref);
    var4 = (VEva/VEva_Ref);
   var5 = (QCon /QRef);
   var6 = (P /PRef);

  // Real A[36,36] = [

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end equationFitModel;
annotation (Documentation(info="<html>
<p>
Package with data for water to water heat pump models implementing both the DOE2 and equation fit methods
<a href=\"modelica://Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater\">
</p>
</html>"));

end PerformanceCurveWaterToWaterHeatPump;

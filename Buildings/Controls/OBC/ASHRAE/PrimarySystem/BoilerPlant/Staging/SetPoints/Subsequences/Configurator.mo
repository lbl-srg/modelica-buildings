within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences;
block Configurator "Configures boiler staging"

  parameter Integer nSta = 5
    "Number of boiler stages";

  parameter Integer nBoi = 3
    "Number of boilers";

  parameter Integer boiTyp[nBoi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler}
    "Boiler type. Recommended staging order: 1. condensing boilers, 2. non-codensing boilers";

  parameter Integer staMat[nSta, nBoi] = {{1,0,0},{0,1,0},{1,1,0},{0,1,1},{1,1,1}}
    "Staging matrix with stage as row index and boiler as column index";

  parameter Real boiDesCap[nBoi](
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Design boiler capacities vector";

  parameter Real boiFirMin[nBoi](
    final unit="1",
    displayUnit="1")
    "Boiler minimum firing ratios vector";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiAva[nBoi]
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAva[nSta]
    "Stage availability status vector"
    annotation (Placement(transformation(extent={{220,-100},{260,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yTyp[nSta](
    final max=fill(nSta, nSta))
    "Boiler stage types vector"
    annotation (Placement(transformation(extent={{220,-140},{260,-100}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCapDes[nSta](
    final unit=fill("W", nSta),
    final quantity=fill("Power", nSta))
    "Stage design capacities vector"
    annotation (Placement(transformation(extent={{220,0},{260,40}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCapMin[nSta](
    final unit=fill("W", nSta),
    final quantity=fill("Power", nSta))
    "Minimum stage capacities vector"
    annotation (Placement(transformation(extent={{220,-40},{260,0}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="The boilers must be tagged in order of design capacity if unequally sized")
    "Asserts whether boilers are tagged in ascending order with regards to capacity"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1[nBoi]
    "Subtracts signals"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax(
    nin=nBoi)
    "Maximum value in a vector input"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));

  Buildings.Controls.OBC.CDL.Reals.Abs abs
    "Absolute values"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr1(
    final t=0.5)
    "Less threshold"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));

protected
  final parameter Integer boiTypMat[nSta, nBoi] = {boiTyp[i] for i in 1:nBoi, j in 1:nSta}
    "Boiler type array expanded to allow for element-wise multiplication with the
    staging matrix";

  final parameter Real boiFirMinVal[nSta, nBoi] = {boiFirMin[i] for i in 1:nBoi, j in 1:nSta}
    "Boiler minimum firing ratio array expanded for element-wise multiplication
    with the staging matrix";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant boiDesCaps[nBoi](
    final k=boiDesCap)
    "Design boiler capacities vector"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant boiFirMinMat[nSta,nBoi](
    final k=boiFirMinVal)
    "Boiler minimum firing ratios matrix"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixGain staDesCaps(
    final K=staMat)
    "Matrix gain for design capacities"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixGain sumNumBoi(
    final K=staMat)
    "Outputs the total boiler count per stage vector"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixGain sumNumAvaBoi(
    final K=staMat)
    "Outputs the available boiler count per stage vector"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant oneVec[nBoi](
    final k=fill(1, nBoi))
    "Mocks a case with all boilers available"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi]
    "Type converter"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2[nSta]
    "Subtracts count of available boilers from the design count, at each stage"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr[nSta](
    final t=fill(0.5, nSta))
    "Checks if the count of available boilers in each stage equals the design count"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant boiStaMat[nSta,nBoi](
    final k=staMat)
    "Staging matrix"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staType[nSta,nBoi](
    final k=boiTypMat)
    "Boiler stage type matrix"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro[nSta,nBoi]
    "Element-wise product"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixMax matMax(
    final nRow=nSta,
    final nCol=nBoi)
    "Row-wise matrix maximum"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sort sort(
    final nin=nSta)
    "Vector sort"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nSta]
    "Integer equality"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="The boilers are not being staged in an order 
    recommended by ASHRAE RP1711 or Guideline 36. 
    Please make sure to follow the recommendation that is:
    any condensing boilers first, any non-condensing boilers last.")
    "Asserts warning if boilers are not staged in recommended order by type"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nSta)
    "Logical and with a vector input"
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro1[nSta,nBoi]
    "Element-wise product"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixMax matMax1(
    final rowMax=true,
    final nRow=nSta,
    final nCol=nBoi)
    "Find highest BFirMin in each stage"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro2[nSta]
    "Product"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sort sort1(
    final nin=nBoi)
    "Sort values"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));

equation
  connect(boiDesCaps.y, staDesCaps.u)
    annotation (Line(points={{-178,110},{-142,110}},
      color={0,0,127}));
  connect(uBoiAva, booToRea.u)
    annotation (Line(points={{-240,-40},{-202,-40}},
      color={255,0,255}));
  connect(booToRea.y,sumNumAvaBoi. u)
    annotation (Line(points={{-178,-40},{-142,-40}},
      color={0,0,127}));
  connect(sumNumBoi.y,sub2. u1)
    annotation (Line(points={{-118,20},{-100,20},{-100,-4},{-82,-4}},
      color={0,0,127}));
  connect(sumNumAvaBoi.y,sub2. u2)
    annotation (Line(points={{-118,-40},{-100.5,-40},{-100.5,-16},{-82,-16}},
      color={0,0,127}));
  connect(sub2.y,lesThr. u)
    annotation (Line(points={{-58,-10},{-42,-10}},
      color={0,0,127}));
  connect(lesThr.y, yAva)
    annotation (Line(points={{-18,-10},{60,-10},{60,-80},{240,-80}},
      color={255,0,255}));
  connect(pro.y,matMax. u)
    annotation (Line(points={{-118,-120},{-102,-120}},
      color={0,0,127}));
  connect(matMax.y,reaToInt. u)
    annotation (Line(points={{-78,-120},{-62,-120}},
      color={0,0,127}));
  connect(reaToInt.y, yTyp)
    annotation (Line(points={{-38,-120},{240,-120}},
      color={255,127,0}));
  connect(reaToInt.y, intToRea1.u)
    annotation (Line(points={{-38,-120},{-30,-120},{-30,-170},{-22,-170}},
      color={255,127,0}));
  connect(intToRea1.y, sort.u)
    annotation (Line(points={{2,-170},{18,-170}},
      color={0,0,127}));
  connect(sort.y, reaToInt1.u)
    annotation (Line(points={{42,-170},{58,-170}},
      color={0,0,127}));
  connect(reaToInt.y,intEqu. u1)
    annotation (Line(points={{-38,-120},{90,-120},{90,-150},{98,-150}},
      color={255,127,0}));
  connect(reaToInt1.y,intEqu. u2)
    annotation (Line(points={{82,-170},{90,-170},{90,-158},{98,-158}},
      color={255,127,0}));
  connect(mulAnd.y, assMes.u)
    annotation (Line(points={{162,-150},{178,-150}},
      color={255,0,255}));
  connect(intEqu.y, mulAnd.u)
    annotation (Line(points={{122,-150},{138,-150}},
      color={255,0,255}));
  connect(staDesCaps.y,yCapDes)
    annotation (Line(points={{-118,110},{100,110},{100,20},{240,20}},
      color={0,0,127}));
  connect(oneVec.y,sumNumBoi. u)
    annotation (Line(points={{-178,20},{-142,20}},
      color={0,0,127}));
  connect(boiStaMat.y, pro.u1)
    annotation (Line(points={{-178,-90},{-160,-90},{-160,-114},{-142,-114}},
      color={0,0,127}));
  connect(staType.y, pro.u2)
    annotation (Line(points={{-178,-150},{-160,-150},{-160,-126},{-142,-126}},
      color={0,0,127}));
  connect(boiFirMinMat.y, pro1.u1)
    annotation (Line(points={{-178,70},{-170,70},{-170,76},{-162,76}},
      color={0,0,127}));
  connect(pro1.u2, boiStaMat.y)
    annotation (Line(points={{-162,64},{-170,64},{-170,-90},{-178,-90}},
      color={0,0,127}));
  connect(pro1.y, matMax1.u)
    annotation (Line(points={{-138,70},{-122,70}},
      color={0,0,127}));
  connect(matMax1.y, pro2.u2)
    annotation (Line(points={{-98,70},{-90,70},{-90,64},{-82,64}},
      color={0,0,127}));
  connect(staDesCaps.y, pro2.u1)
    annotation (Line(points={{-118,110},{-90,110},{-90,76},{-82,76}},
      color={0,0,127}));
  connect(pro2.y,yCapMin)
    annotation (Line(points={{-58,70},{80,70},{80,-20},{240,-20}},
      color={0,0,127}));

  connect(boiDesCaps.y,sub1. u2) annotation (Line(points={{-178,110},{-160,110},
          {-160,154},{-102,154}}, color={0,0,127}));
  connect(sort1.y,sub1. u1) annotation (Line(points={{-118,170},{-110,170},
          {-110,166},{-102,166}}, color={0,0,127}));
  connect(sub1.y, multiMax.u) annotation (Line(points={{-78,160},{-70,160},
          {-70,160},{-62,160}}, color={0,0,127}));
  connect(multiMax.y, abs.u)
    annotation (Line(points={{-38,160},{-22,160}}, color={0,0,127}));
  connect(abs.y, lesThr1.u)
    annotation (Line(points={{2,160},{18,160}}, color={0,0,127}));
  connect(lesThr1.y, assMes1.u)
    annotation (Line(points={{42,160},{58,160}}, color={255,0,255}));
  connect(sort1.u, boiDesCaps.y) annotation (Line(points={{-142,170},{-160,
          170},{-160,110},{-178,110}}, color={0,0,127}));
  annotation (defaultComponentName = "conf",
    Icon(graphics={
           Rectangle(extent={{-100,-100},{100,100}},
                     lineColor={0,0,127},
                     fillColor={255,255,255},
                     fillPattern=FillPattern.Solid),
                Text(extent={{-120,146},{100,108}},
                     textColor={0,0,255},
                     textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-220,-200},{220,200}})),
    Documentation(info="<html>
      <p>
      This subsequence is not directly specified in 1711 as it provides
      a side calculation pertaining to generalization of the staging 
      sequences for any number of boilers and stages provided by the 
      user.
      </p>
      <p>
      Given the staging matrix input parameter <code>staMat</code> the staging
      configurator calculates:
      </p>
      <ul>
      <li>
      Stage availability vector <code>yAva</code> from the boiler availability
      <code>uBoiAva</code> input vector according to RP-1711 March 2020 Draft
      section 5.3.3.9.
      </li>
      <li>
      Design stage capacity vector <code>yDesCap</code> from the design boiler
      capacity vector input parameter <code>boiDesCap</code>.
      </li>
      <li>
      Minimum stage capacity vector <code>yMinCap</code> from the boiler minimum
      firing rate input parameter <code>boiMinCap</code> according to section
      5.3.3.8, 1711 March 2020 Draft.
      </li>
      <li>
      Stage type vector <code>yTyp</code> from the boiler type vector input
      parameter <code>boiTyp</code>. Boiler types are defined in
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes</a>.<br/>
      Stage type is based on the boiler types in that stage, and is classified
      as:
      <ol>
      <li>
      non-condensing, if any of the boilers in that stage are non-condensing boilers.
      </li>
      <li>
      condensing, if all the boilers in that stage are condensing boilers.
      </li>
      </ol>
      This stage type is used to determine the stage up and down conditions to apply.
      </li>
      </ul>
      </html>",
      revisions="<html>
      <ul>
      <li>
      May 20, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end Configurator;

within Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids;
record Ethanol "Data record for ethanol"
  extends Generic(
    T = {263.15,289.99,316.83,343.67,370.51,397.35,424.19,451.03,477.87,504.71},
    p = {7.68935806e+02,4.84994352e+03,2.15631130e+04,7.35709800e+04,
 2.04608185e+05,4.84534468e+05,1.00876141e+06,1.89191100e+06,
 3.26351138e+06,5.28216519e+06},
    dTRef = 30,
    sSatLiq = {-726.97385178,-505.58351399,-286.35608663, -65.6269501 , 159.00728335,
  389.52712665, 627.10333295, 869.93175618,1118.15718199,1411.00636633},
    sSatVap = {2902.95247846,2699.03239847,2551.22744387,2442.9032679 ,2361.50449434,
 2297.49098694,2243.29415924,2191.50899933,2129.79172102,2005.32409461},
    sRef = {3048.94776591,2841.66534391,2692.53179397,2585.15729656,2507.38571993,
 2450.24466807,2407.20042497,2373.31066643,2343.95130719,2312.82860368},
    hSatLiq = {-223584.40304912,-162359.29205049, -95822.15864817, -22850.99437918,
   57554.39892164, 146473.20020843, 244865.51546993, 352554.40508651,
  470265.91162174, 618471.16252163},
    hSatVap = {731630.7107534 ,766947.27640316,803209.43132073,839255.58564097,
 873601.64056746,904602.64009225,930437.50207646,948625.38906467,
 953695.70879138,918429.26315737},
    hRef = { 772225.37152735, 810437.15602944, 850086.3207255 , 890262.5453897 ,
  929818.50188979, 967557.52939027,1002370.80023191,1033259.20131376,
 1059056.68109972,1077479.39606047});
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "pro",
  Documentation(info="<html>
<p>
Record containing properties of ethanol.
Its name in CoolProp is \"Ethanol\".
A figure in the documentation of
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Cycle\">
Buildings.Fluid.CHPs.OrganicRankine.Cycle</a>
shows which lines these arrays represent.
</p>
</html>"));
end Ethanol;
(function($)
{
    if (/English/.test($("#ds-language-selection > a > span").text()))
    {
        $("h2, li, a, a > span, head > title").each(function ()
        {
            if ($(this).text() == "Alle Publikationen") {
                $(this).text("All Publications");
            }
	    if ($(this).text() == "Energie, Ressourcen, Umwelt") {
                $(this).text("Energy, Resources, Environment");
            }
            if ($(this).text() == "Geochemie, Mineralogie, Petrologie") {
                $(this).text("Geochemistry, Mineralogy, Petrology");
            }
	    if ($(this).text() == "Geographie, Hydrologie") {
                $(this).text("Geography, Hydrology");
            }
            if ($(this).text() == "Geologie") {
                $(this).text("Geology");
            }
            if ($(this).text() == "Geophysik, Extraterrestische Forschung") {
                $(this).text("Geophysics, Extraterrestrial Research");
            }
            if ($(this).text() == "Paläontologie, Geobiologie") {
                $(this).text("Paleontology, Geobiology");
            }
	    if ($(this).text() == "Institutionelle Serien und Zeitschriften") {
                $(this).text("Institutional Periodicals and Journals");
            }
        });
    }

})(jQuery);

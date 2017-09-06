# This shell library is meant to be used with `set -e` and `set -u`.

po_languages () {
   for po in po/*.po ; do
      rel="${po%.po}"
      echo "${rel#po/}"
   done
}

diff_without_pot_creation_date () {
    diff --ignore-matching-lines '^"POT-Creation-Date:' "${@}"
}

diff_without_pot_creation_date_and_comments () {
    diff --ignore-matching-lines '^"POT-Creation-Date:' \
         --ignore-matching-lines '^#: .*:[0-9]\+$' "${@}"
}

intltool_update_po () {
   (
        cd po
        for locale in "$@" ; do
            intltool-update --dist --gettext-package=tails $locale -o ${locale}.po.new

            [ -f ${locale}.po ]     || continue
            [ -f ${locale}.po.new ] || continue

            if [ "${FORCE}" = yes ]; then
                echo "Force-updating '${locale}.po'."
                mv ${locale}.po.new ${locale}.po
            elif diff_without_pot_creation_date "${locale}.po" "${locale}.po.new" >/dev/null; then
                    echo "${locale}: Only header changes in PO file, delete new PO file."
                    rm ${locale}.po.new
            else
                echo "${locale}: Real changes in PO file: substitute old PO file."
                mv ${locale}.po.new ${locale}.po
            fi
        done
    )
}

# Assembler-RISCV
Questo codice sembra essere scritto in assembly RISC-V. Esamina una serie di operazioni su una stringa di testo in base a un codice specificato all'inizio del programma. Ecco un riassunto delle principali funzioni:

caesars: Applica la cifratura di Cesare alla stringa di testo usando una chiave specificata.
d_caesars: Decifra la stringa di testo cifrata con la cifratura di Cesare utilizzando la stessa chiave.
blocks: Applica una trasformazione tramite una chiave specifica sulla stringa di testo. La trasformazione sembra essere basata su blocchi di caratteri e una chiave di lunghezza variabile.
d_blocks: Decifra la stringa di testo trasformata con la funzione blocks utilizzando la stessa chiave.
ocurrences: Analizza la stringa di testo per individuare la frequenza di determinati caratteri.
d_ocurrences: Decifra la stringa di testo codificata dalla funzione ocurrences.
dictionary: Sostituisce i caratteri della stringa di testo con quelli corrispondenti nel dizionario fornito.
d_dictionary: Effettua la decodifica della stringa di testo codificata con la funzione dictionary.
inversion: Inverte l'ordine dei caratteri nella stringa di testo.
d_inversion: Decifra la stringa di testo codificata con la funzione inversion.
Il programma sembra anche gestire l'input/output tramite system call specifiche del sistema operativo su cui viene eseguito. La logica di controllo principale sembra essere basata su un ciclo che legge il codice specificato e chiama le funzioni appropriate.

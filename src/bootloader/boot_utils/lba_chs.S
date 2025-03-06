%ifndef __LBA_CHS_S
%define __LBA_CHS_S
;
; Converts an LBA address to a CHS address
; Parameters:
;   - ax: LBA address
; Returns:
;   - cx [bits 0-5]:  sector number
;   - cx [bits 6-15]: cylinder
;   - dh: head
;

lba_to_chs:
    push ax
    push dx

    xor dx, dx                          ; dx = 0
    div word [BPB_SecPerTrk]            ; ax = LBA / SectorsPerTrack
                                        ; dx = LBA % SectorsPerTrack
    inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
    mov cx, dx                          ; cx = sector

    xor dx, dx                          ; dx = 0
    div word [BPB_NumHeads]             ; ax = (LBA / SectorsPerTrack) / Heads = cylinder
                                        ; dx = (LBA / SectorsPerTrack) % Heads = head
    mov dh, dl                          ; dh = head
    mov ch, al                          ; ch = cylinder (lower 8 bits)
    shl ah, 6
    or cl, ah                           ; put upper 2 bits of cylinder in CL

    pop ax
    mov dl, al                          ; restore DL
    pop ax
    ret

%endif

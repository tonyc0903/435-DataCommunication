# By Tony Chen
import random


def data_layer(error, framecost, frameerrorcost):
    # this list is for certain frames per packet. For now is 10 if want to change # of frames per packet you
    # have to also change lines 55
    packet_outcome = [False] * 10
    # packet number
    packet = 1
    # index holder for frames in packet_outcome
    count = 0
    # total cost or average cost
    totalcost = 0
    # frame number indicating the current frame out of total 10
    frame = 1
    # track how many frames failed
    failed = 0
    # total # of packets to send
    totalpacket = 100

    i = 0
    while packet <= totalpacket:
        print("Starting packet: ", packet)
        while i < len(packet_outcome):
            x = random.uniform(0, 1)

            # transmitting frame cost and error checking costs
            totalcost += (framecost + frameerrorcost)
            print("Sending frame", frame, "...")
            # if it fails
            if x <= error:
                print("Resending frame", frame, "because failed")
                failed += 1
                continue
            
            # if it passes go to next frame and update current frame in packet outcome to True
            else:
                print("Frame ", frame, "success")
                frame += 1
                packet_outcome[count] = True
                print(packet_outcome)
                count += 1
                i += 1
                # print(totalcost)
                continue

        # if all frames are successful
        print("Packet", packet, "Success")
        packet += 1
        print("\n")

        # resetting values for next packet until 100
        i = 0
        count = 0
        frame = 1
        packet_outcome = [False] * 10
        continue

    # when the while loop stops print the average cost
    print("Data Link Layer Average packet cost", round(totalcost, 3)/totalpacket, "cents")
    print("Data Link Layer Total packet cost", round(totalcost, 3), "cents")
    print("Total frames failed", failed)
    print("\n\n")


def TCP_layer(error, packetcost, packeterrorcost):
    # this list is for certain frames per packet. For now is 10 if want to switch have to also change lines 120 & 132
    packet_outcome = [False] * 10
    # packet number
    packet = 1
    # index holder for frames in packet_outcome
    count = 0
    # total cost or average cost
    totalcost = 0
    # frame number indicating the current frame out of total 10
    frame = 1
    # boolean to check if a frame failed or not
    checker = False
    # track total number of packet send/resend
    packet_send_or_resend = 1
    # track total frames failed
    failed = 0
    i = 0
    totalpacket = 100

    while packet <= totalpacket:
        print("Starting packet: ", packet)
        packet_send_or_resend += 1
        while i < len(packet_outcome):
            x = random.uniform(0, 1)
            # transmitting frame cost and error checking costs (change accordingly)
            totalcost += 10 + 1.2
            # if frame fails go to next frame
            if x <= error:
                print("Frame", frame, "has failed")
                i += 1
                count += 1
                frame += 1
                checker = True
                failed += 1
                continue

            # if it passes go to next frame and update current frame in packet outcome to True
            else:
                print("Frame ", frame, "success")
                frame += 1
                packet_outcome[count] = True
                print(packet_outcome)
                count += 1
                i += 1
                continue

        # transmitting packet and error checking costs
        totalcost += packet_send_cost + packet_error_check_cost

        # if at least one frame failed, packet will resend again
        if checker:
            print("Packet has failed, resending....\n\n")
            packet_send_or_resend += 1
            frame = 1
            count = 0
            i = 0
            checker = False
            packet_outcome = [False] * 10
            continue

        # if all frames are successful
        else:
            print("Packet", packet, "Success")
            packet += 1
            print("\n\n")
            # resetting values for next packet until 100
            i = 0
            count = 0
            frame = 1
            packet_outcome = [False] * 10

            continue

    print("TCP Layer Average Cost", round(totalcost/packet_send_or_resend, 3), "cents")
    print("TCP Layer Total packet cost", round(totalcost, 3), "cents")
    print("Total packet resend/send", packet_send_or_resend)

# change values according to your desires

error_Prob = 0.001
frame_send_Cost = 10
frame_error_check_cost = 1.2
packet_send_cost = 100
packet_error_check_cost = 10
print("Starting Data Link Layer\n\n")
data_layer(error_Prob, frame_send_Cost, frame_error_check_cost)
print("Starting TCP Layer\n\n")
TCP_layer(error_Prob, packet_send_cost, packet_error_check_cost)






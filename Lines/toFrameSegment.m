function [S_F,SF_f,SF_sw] = toFrameSegment(F,S_W)

% TOFRAMESEGMENT  Express in local frame a set of segments from global frame
%   TOFRAMESEGMENT(F,S_W)  takes the W-referenced segments matrix S_W and
%   returns it in frame F.
%   S_W is a segments matrix defined as
%       S_W  = [S_1 S_2 ... S_N], where
%       S_I  = [P_i1;P_i2]      are the segments
%       P_ij = [x_ij;y_ij;z_ij] are the segments' endpoints
%
%   F is either a structure containing at least:
%     t : frame position
%     q : frame orientation quaternion
%     Rt: transposed rotation matrix
%     Pc: Conjugated Pi matrix
%
%   or a 7-vector F = [t;q].
%
%   [S_F,SF_f,SF_sw] = ... returns the Jacobians of toFrameSegments:
%     SF_f:  wrt the frame
%     SF_sw: wrt the segment
%   Note that this is only available for single segments.
%
%   See also TOFRAME.

s = size(S_W,2); % number of points in input matrix

if s==1 % one segment

    S_F = [...
        toFrame(F,S_W(1:3))
        toFrame(F,S_W(4:6))];
   
    if nargout > 1 % Jacobians
        [P1_F,P1F_f,P1F_p1w] = toFrame(F,S_W(1:3,:));
        [P2_F,P2F_f,P2F_p2w] = toFrame(F,S_W(4:6,:));
        S_F = [P1_F;P2_F];
        SF_f = [P1F_f;P2F_f];
        SF_sw = blkdiag(P1F_p1w,P2F_p2w);
    end

else % multiple points
    
    S_F = [...
        toFrame(F,S_W(1:3,:))
        toFrame(F,S_W(4:6,:))];
    if nargout > 1
        warning('Can''t give Jacobians for multiple segments');
    end
end